extends Node2D

# export(bool) var check_player = false

var player_clicked: bool = false
var sprite_clicked: bool = false
var mouse_in_text_select: bool = false
var mouse_in_dialog_box: bool = false
var active = false

onready var world = get_node("/root/MainScene")
onready var dialog_box = get_node("/root/MainScene/StaticHud/DialogBox")
onready var hud = get_node("/root/MainScene/Hud")
onready var player_objects = get_node("/root/MainScene/Scene/Player")
onready var splashscreen = get_node("/root/MainScene/StaticHud/Splashscreen")
var dialog_select = null
var input_handled = false

enum GAME_STATE { INTERACT, SELECT_DIALOG, DIALOG, SPLASHSCREEN, CHANGE_ROOM }

var game_state = GAME_STATE.INTERACT


func open_dialog_box(dialog_id: String, num_of_pages: int):
	self.dialog_box.open_dialog_box(dialog_id, num_of_pages)


func change_room(scene: String, spawn: String):
	self.world.load_room(scene, spawn)


func close_dialog_select():
	if self.dialog_select:
		self.dialog_select.close()


func show_splashscreen(path: String, dialog_id: String, num_of_pages: int):
	splashscreen.show_splashscreen(path, dialog_id, num_of_pages)


func is_mouse_click(event: InputEvent):
	return event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT


func is_touch_tap(event: InputEvent):
	return event is InputEventSingleScreenTap and event.pressed


func is_mouse_click_or_touch_tap_event(event: InputEvent):
	return is_mouse_click(event) or is_touch_tap(event)


func _input(event: InputEvent):
	if not self.active:
		return
	match self.game_state:
		GAME_STATE.INTERACT:
			if not self.is_mouse_click_or_touch_tap_event(event) or dialog_box.closing_dialog_box:
				return

			get_tree().set_input_as_handled()

			var space_state = get_world_2d().direct_space_state
			var interactables = space_state.intersect_point(
				get_global_mouse_position(), 32, [], 2147483647, false, true
			)
			if (
				len(interactables) == 0
				or not interactables[-1]["collider"].get_parent().is_in_group("interactable")
			):
				return
			interactables[-1]["collider"].get_parent().clicked()

		GAME_STATE.SELECT_DIALOG:
			if self.is_mouse_click(event):
				if self.mouse_in_text_select:
					self.dialog_select.process_click()
					get_tree().set_input_as_handled()
				else:
					self.dialog_select.close()
					self.mouse_in_text_select = false
		_:
			return
