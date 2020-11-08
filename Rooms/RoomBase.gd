extends Node2D


export(Vector2) var cameraHorizontalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraVerticalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraHorizontalMobileLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraVerticalMobileLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraZoom = Vector2(1, 1)
export(String, FILE, "*.json") var objects_data_path = ""
export(String) var room_name = ""
export(String) var audio_name = ""

const ObjectBase = preload("res://Objects/ObjectBase.tscn")
const ObjectBaseWithoutSprite = preload("res://Objects/ObjectBaseWithoutSprite.tscn")

onready var object_container = $Objects
onready var world_state = get_node("/root/MainScene").world_state
onready var audio_player = WorldController.get_audio_player("world")
var objects_data
var spawns = {}


func vecFromArray(arr: Array) -> Vector2:
	return Vector2(arr[0], arr[1])


func _ready():
	var camera = get_node("/root/MainScene/Camera")
	var limitsH
	var limitsV
	if WorldController.is_mobile:
		limitsH = cameraHorizontalMobileLimits
		limitsV = cameraVerticalMobileLimits
	else:
		limitsH = cameraHorizontalLimits
		limitsV = cameraVerticalLimits
	camera.limit_left = limitsH.x
	camera.limit_right = limitsH.y
	camera.limit_top = limitsV.x
	camera.limit_bottom = limitsV.y
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
	set_audio()	


func set_audio():
	if self.audio_name:
		if not audio_player.is_playing(audio_name):
			audio_player.set_audio(self.audio_name)
	else:
		audio_player.stop_audio()
