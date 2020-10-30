extends Node

# export(bool) var check_player = false

var player_clicked: bool = false
var sprite_clicked: bool = false
var mouse_in_text_select: bool = false
var mouse_in_dialog_box: bool = false
var splashscreen: bool = false
var active = false

onready var dialog_box = get_node("/root/MainScene/StaticHud/DialogBox")
onready var hud = get_node("/root/MainScene/Hud")
onready var player_objects = get_node("/root/MainScene/Scene/Player")
var objects
var dialog_select = null
var input_handled = false


func set_objects_parent(value):
	self.objects = value.get_children()
	self.objects.invert()


func _input(event: InputEvent):
	if not (active and objects) or splashscreen:
		return
	if (
		(event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT)
		or (event is InputEventSingleScreenTap and event.pressed)
	):
		print(mouse_in_text_select)
		if dialog_select:
			if mouse_in_text_select:
				dialog_select.process_click()
				get_tree().set_input_as_handled()
				return
			else:
				hud.remove_child(dialog_select)
				mouse_in_text_select = false
		
		input_handled = player_clicked or sprite_clicked
		# print("player_clicked ", player_clicked, " sprite_clicked ", sprite_clicked)
		if dialog_box or input_handled or mouse_in_dialog_box:
			get_tree().set_input_as_handled()
		
		if dialog_box and (mouse_in_dialog_box or dialog_box.closing_dialog_box):
			player_clicked = false
			sprite_clicked = false
			return
		
		if player_clicked:
			player_clicked = false
			# TODO
			return
		elif sprite_clicked:
			sprite_clicked = false
			for i in objects:
				if i.is_visible() and i.mouse_in_area:
					i.open_dialog_select()
					return
