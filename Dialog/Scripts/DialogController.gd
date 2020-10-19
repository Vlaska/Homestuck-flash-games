extends Node


# export(bool) var check_player = false

var player_clicked: bool = false
var sprite_clicked: bool = false
var mouse_in_text_select: bool = false
var active = false

onready var dialog_box = get_node("/root/MainScene/StaticHud/DialogBox")
onready var hud = get_node("/root/MainScene/Hud")
onready var player_objects = get_node("/root/MainScene/Scene/Player")
var objects_parent


# func _ready():
# 	load_objects_parent(get_node("/root/MainScene/Scene/Room/Objects"))


func set_objects_parent(value):
	self.objects_parent = value


func _process(_delta):
	# var tmp = hud.get_node("DialogSelect")
	# if tmp:
	# 	hud.remove_child(tmp)
	if not (active and objects_parent):
		return

	if dialog_box:
		if dialog_box.mouse_in_dialog_box or dialog_box.closing_dialog_box:
			player_clicked = false
			sprite_clicked = false
			return
	if player_clicked:
		player_clicked = false
		pass
	elif sprite_clicked:
		sprite_clicked = false
			
		var objects = objects_parent.get_children()
		objects.invert()
		for i in objects:
			if i.is_visible() and i.mouse_in_area:
				i.open_dialog_select()
				return


func _input(event: InputEvent):
	if not active:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var tmp = hud.get_node("DialogSelect")
		# print(tmp)
		print(tmp, " ", mouse_in_text_select)
		if tmp and not mouse_in_text_select:
			print(sprite_clicked)
			hud.remove_child(tmp)
			mouse_in_text_select = false
# 		if dialog_box.mouse_in_dialog_box:
# 			return
# 		if check_player:
# 			return
# 		var objects = objects_parent.get_children()
# 		objects.invert()
# 		for i in objects:
# 			if i.is_visible() and i.mouse_in_area:
# 				i.open_dialog_select(event.position)
# 				return
	# elif event is InputEventScreenTouch and event.pressed:
	# 	if OS.has_feature("JavaScript"):
	# 		JavaScript.eval("console.log('Touch test')")
