extends Node2D


onready var camera = $Camera
onready var john = $Scene/Player/John
onready var staticHud = $StaticHud
onready var display_width = ProjectSettings.get("display/window/size/width")
onready var fps_label = $StaticHudWholeScreen/FPS
var objects

export(String, FILE, "*.json") var room_list_path
export(bool) var dialog_active = true setget set_dialog_active, get_dialog_active

onready var transition_effect = $StaticHudWholeScreen/RoomTransition/AnimationPlayer

const mapList = [
	"res://Rooms/Balcony/Balcony.tscn",
	"res://Rooms/Bathroom/Bathroom.tscn",
	"res://Rooms/BathroomCorridor/BathroomCorridor.tscn",
	"res://Rooms/JohnsRoom/JohnsRoom.tscn",
	"res://Rooms/Kitchen/Kitchen.tscn",
	"res://Rooms/Laundry/Laundry.tscn",
	"res://Rooms/MainRoom/MainRoom.tscn",
	"res://Rooms/Outside/Outside.tscn",
	"res://Rooms/PS/PS.tscn",
	"res://Rooms/StudyRoom/StudyRoom.tscn"
]

var currentMap = 0


var rooms: Dictionary
var john_spawn_name: String
var new_room_name: String

var world_state = {}
# {
#	"room_name": {
#		"objects": {
#			"obj_name": [
#				 "DIALOG_0", 
#				 "DIALOG_5"
# 			]
#		},
#		"data": {
#			{...}
#		}
# 	}
# }


func vecFromArray(arr: Array) -> Vector2:
	return Vector2(arr[0], arr[1])


func get_dialog_active():
	return dialog_active


func set_dialog_active(value: bool):
	dialog_active = value
	WorldController.active = value


func load_maps_data():
	var objects_data_file = File.new()
	if not objects_data_file.file_exists(room_list_path):
		print("File with room data not found: ", room_list_path)
		return
	objects_data_file.open(room_list_path, File.READ)
	var parsed_json = JSON.parse(objects_data_file.get_as_text())
	if not (parsed_json.result is Dictionary):
		print("World data: ", parsed_json.error_string, ", at ", parsed_json.error_line)

	var out = parsed_json.result
	objects_data_file.close()
	return out


func _ready():
	transition_effect.play("HideBg")
	get_viewport().connect("size_changed", self, "offset_static_hud")
	offset_static_hud()
	WorldController.active = dialog_active
	VisualServer.set_default_clear_color(Color(1, 1, 1, 1))
	var data = load_maps_data()
	if data:
		rooms = data["rooms"]
		load_room(data["start"]["room"], data["start"]["spawn"])


func _process(_delta):
	fps_label.text = str(Engine.get_frames_per_second())
	sort_objects()


func sort_objects():
	if objects:
		var john_position = john.position.y
		for i in objects:
			if i.position.y <= john_position:
				i.z_index = 0
			else:
				i.z_index = 1


func offset_static_hud():
	var size = get_viewport().size
	staticHud.offset.x = (size.x - display_width) / 2


func change_map():
	var scene = $Scene
	var old_room = $Scene/Room
	if old_room:
		scene.remove_child(old_room)
		old_room.queue_free()
	var new_room = load(rooms[new_room_name]).instance()
	new_room.name = "Room"
	scene.add_child(new_room)
	scene.move_child(new_room, 0)
	self.objects = new_room.get_node("Objects").get_children()
	self.john.position = vecFromArray(world_state[new_room_name]["data"]["spawns"][john_spawn_name])
	self.camera.position = self.john.position
	WorldController.game_state = WorldController.GAME_STATE.INTERACT
	new_room.on_load()


func start_changing_room():
	transition_effect.play("FadeIn")
	WorldController.game_state = WorldController.GAME_STATE.CHANGE_ROOM
	
	
func change_room():
	change_map()
	transition_effect.play("FadeOut")


func load_room(room_name, spawn):
	john_spawn_name = spawn
	new_room_name = room_name
	start_changing_room()

