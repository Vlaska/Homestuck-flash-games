extends Node2D


export(Vector2) var cameraHorizontalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraVerticalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraZoom = Vector2(1, 1)
export(String, FILE, "*.json") var objects_data_path = ""
export(String) var room_name = ""
export(String, FILE, "*.ogg,*.wav") var audio_file = ""

const ObjectBase = preload("res://Objects/ObjectBase.tscn")
const ObjectBaseWithoutSprite = preload("res://Objects/ObjectBaseWithoutSprite.tscn")

onready var object_container = $Objects
onready var world_state = get_node("/root/MainScene").world_state
var objects_data
var spawns = {}


func vecFromArray(arr: Array) -> Vector2:
	return Vector2(arr[0], arr[1])


func _ready():
	var camera = get_node("/root/MainScene/Camera")
	camera.limit_left = cameraHorizontalLimits.x
	camera.limit_right = cameraHorizontalLimits.y
	camera.limit_top = cameraVerticalLimits.x
	camera.limit_bottom = cameraVerticalLimits.y
	camera.zoom = cameraZoom

	if not(room_name in world_state):
		objects_data = WorldController.load_data_from_file(objects_data_path)
		if not objects_data:
			push_error("Error parsing room data: " + room_name)
			return

		var objects = {}
		for key in objects_data["objects"]:
			objects[key] = []
			for i in objects_data["objects"][key]["prompts"]:
				match i:
					{"sequence": _, "first": var first}:
						objects[key].append(first)

		world_state[room_name] = {
			"objects": objects,
			"data": objects_data
		}
	else:
		objects_data = world_state[room_name]["data"]
	
	create_objects(objects_data)


func set_object_data(obj, data):
	if "offset" in data:
		obj.offset = vecFromArray(data["offset"])
	if "pos" in data:
		obj.position = vecFromArray(data["pos"])
	obj.set_collision_position(obj.offset)
	if "scale" in data:
		obj.scale = vecFromArray(data["scale"])


func create_objects(data: Dictionary):
	for i in data["objects"]:
		var t
		var ob_data = data["objects"][i]
		var object
		if "parent" in ob_data:
			t = data["objects"][ob_data["parent"]]
			object = ObjectBaseWithoutSprite.instance()
		else:
			t = ob_data
			object = ObjectBase.instance()
		if "script" in ob_data:
			var script = load(ob_data["script"])
			if script:
				object.set_script(script)
		object.init(world_state[room_name]["objects"], i, ob_data)
		set_object_data(object, t)
		self.object_container.add_child(object)


func on_load():
	if self.audio_file:
		WorldController.set_audio(self.audio_file)
	else:
		WorldController.remove_audio()
