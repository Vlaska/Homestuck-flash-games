extends Node2D


onready var camera = $Camera
onready var john = $Scene/Player/John
onready var objects = $Scene/Room/Objects.get_children()
onready var staticHud = $StaticHud
onready var display_width = ProjectSettings.get("display/window/size/width")
var font_size: float = 14


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


func get_dialog_active():
	return dialog_active


func set_dialog_active(value: bool):
	dialog_active = value
	DialogController.active = value


func _ready():
	get_viewport().connect("size_changed", self, "offset_static_hud")
	if OS.has_feature("JavaScript"):
		var is_mobile = JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)")
		if is_mobile:
			font_size = 24
	offset_static_hud()
	DialogController.active = dialog_active


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
		change_map()
	elif Input.is_action_just_pressed("nextMap"):
		currentMap += 1
		if currentMap >= mapList.size():
			currentMap = 0
		change_map()


func change_map():
	var scene = $Scene
	var room = $Scene/Room
	scene.remove_child(room)
	room = load(mapList[currentMap]).instance()
	room.name = "Room"
	scene.add_child(room)
	scene.move_child(room, 0)
	self.objects = room.get_node("Objects").get_children()
