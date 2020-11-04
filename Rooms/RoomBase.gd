extends Node2D


export(Vector2) var cameraHorizontalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraVerticalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraZoom = Vector2(1, 1)
export(String, FILE, "*.json") var objects_data_path = ""
export(String) var room_name = ""

var ObjectBase = preload("res://Objects/ObjectBase.tscn")

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


func create_objects(data: Dictionary):
	for i in data["objects"]:
		var object = ObjectBase.instance()
		var ob_data = data["objects"][i]
		object.init(world_state[room_name]["objects"], i, ob_data)
		if "offset" in ob_data:
			object.offset = vecFromArray(ob_data["offset"])
		if "pos" in ob_data:
			object.position = vecFromArray(ob_data["pos"])
		object.set_collision_position(object.offset)
		if "scale" in ob_data:
			object.scale = vecFromArray(ob_data["scale"])
		self.object_container.add_child(object)


func on_load():
	pass
