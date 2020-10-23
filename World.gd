extends Node2D


onready var camera = $Camera
onready var john = $Scene/Player/John
onready var objects = $Scene/Room/Objects.get_children()
onready var staticHud = $StaticHud
onready var display_width = ProjectSettings.get("display/window/size/width")
var font_size: float = 14

export(String, FILE, "*.json") var room_list_path
export(bool) var dialog_active = true setget set_dialog_active, get_dialog_active

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
	DialogController.active = value


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
	get_viewport().connect("size_changed", self, "offset_static_hud")
	var device_type = OS.get_name().to_lower()
	if OS.has_feature("JavaScript"):
		var is_mobile = JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)")
		if is_mobile:
			font_size = 24
	elif device_type == 'android' or device_type == 'ios':
		font_size = 24
	offset_static_hud()
	DialogController.active = dialog_active
	VisualServer.set_default_clear_color(Color(1, 1, 1, 1))
	var data = load_maps_data()
	if data:
		rooms = data["rooms"]
		load_room(data["start"]["room"], data["start"]["spawn"])


func _process(_delta):
	sort_objects()


func sort_objects():
	var john_position = john.position.y
	# var prev
	for i in objects:
		# prev = i.z_index
		if i.position.y <= john_position:
			i.z_index = 0
		else:
			i.z_index = 1
		# if prev != i.z_index:
		# 	print(i.name, ": ", prev, " ", i.z_index)


func offset_static_hud():
	var size = get_viewport().size
	staticHud.offset.x = (size.x - display_width) / 2


func _input(_event: InputEvent):
	if Input.is_action_just_pressed("prevMap"):
		currentMap -= 1
		if currentMap < 0:
			currentMap = mapList.size() - 1
		# change_room()
		change_map()
	elif Input.is_action_just_pressed("nextMap"):
		currentMap += 1
		if currentMap >= mapList.size():
			currentMap = 0
		# change_room()
		change_map()


func change_map():
	var scene = $Scene
	var old_room = $Scene/Room
	if old_room:
		scene.remove_child(old_room)
	var new_room = load(rooms[new_room_name]).instance()
	new_room.name = "Room"
	scene.add_child(new_room)
	scene.move_child(new_room, 0)
	self.objects = new_room.get_node("Objects").get_children()
	self.john.position = vecFromArray(world_state[new_room_name]["data"]["spawns"][john_spawn_name])
	self.camera.position = self.john.position


func start_changing_room():
	$StaticHudWholeScreen/RoomTransition/AnimationPlayer.play("FadeIn")


func change_room():
	change_map()
	$StaticHudWholeScreen/RoomTransition/AnimationPlayer.play("FadeOut")


func load_room(room_name, spawn):
	john_spawn_name = spawn
	new_room_name = room_name
	start_changing_room()

