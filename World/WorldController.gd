extends Node2D

# export(bool) var check_player = false

var player_clicked: bool = false
var mouse_in_text_select: bool = false
var mouse_in_dialog_box: bool = false
var active = false

const DialogSelect = preload("res://Dialog/DialogSelect.tscn")
const InternalAudioPlayer = preload("res://InternalAudioPlayer.tscn")
const ExternalAudioPlayer = preload("res://ExternalAudioPlayer.tscn")

onready var world = get_node("/root/MainScene")
onready var dialog_box = get_node("/root/MainScene/StaticHud/DialogBox")
onready var hud = get_node("/root/MainScene/Hud")
onready var john = get_node("/root/MainScene/Scene/Player/John")
onready var splashscreen = get_node("/root/MainScene/StaticHud/Splashscreen")
onready var dpad = get_node("/root/MainScene/StaticHudWholeScreen/DPad")
onready var interact_button = get_node("/root/MainScene/StaticHudWholeScreen/InteractButton")
onready var static_hud = get_node("/root/MainScene/StaticHudWholeScreen")
onready var game_info_button = get_node("/root/MainScene/StaticHudWholeScreen/GameInfoDialog")
onready var audio_player = $Audio
var click_position: Vector2 = Vector2.ZERO
var dialog_select = null
var is_mobile: bool = false
var font_size: int = 14
var last_clicked_object = null
var is_browser: bool = false
var external_audio_menager_loaded = false

export(float) var change_state_input_delay: float = 0.5
var timer: float = 0.0

var num_interactive_elements_under_mouse: int = 0

enum GAME_STATE { INTERACT, SELECT_DIALOG, DIALOG, SPLASHSCREEN, CHANGE_ROOM, LOADING }

var game_state = GAME_STATE.LOADING setget set_game_state, get_game_state


func set_game_state(value):
	game_state = value
	timer = 0
	match value:
		GAME_STATE.INTERACT, GAME_STATE.DIALOG, GAME_STATE.CHANGE_ROOM:
			dpad.visible = true
			interact_button.visible = false
		GAME_STATE.SELECT_DIALOG:
			dpad.visible = true
			interact_button.visible = true
		GAME_STATE.SPLASHSCREEN:
			dpad.visible = false
			interact_button.visible = false


func get_game_state():
	return game_state


func get_audio_player(name: String):
	return self.get_node(name)


func create_audio_player(name, files, loop):
	if is_browser:
		ExternalAudioPlayer.instance().init(files, name, loop)
	else:
		InternalAudioPlayer.instance().init(files, name, loop)


func _ready():
	var device_type = OS.get_name().to_lower()
	if OS.has_feature("JavaScript"):
		is_browser = true
		is_mobile = JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)")
		UpdateTimer.connect("timeout", self, "set_up_external_audio")
	elif device_type == 'android' or device_type == 'ios':
		is_mobile = true
		set_up_audio()
	else:
		set_up_audio()
	# if is_mobile:
	# 	font_size = 24
	Input.set_custom_mouse_cursor(load("res://MouseAndButtons/Graphics/MouseCursor.png"), Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(load("res://MouseAndButtons/Graphics/HandCursor.png"), Input.CURSOR_POINTING_HAND)
	decrease_num_interactive_elements_under_mouse()
	

func set_up_external_audio():
	if JavaScript.eval("audio_menager_loaded"):
		set_up_audio()
		external_audio_menager_loaded = true
		UpdateTimer.disconnect("timeout", self, "set_up_external_audio")


func set_up_audio():
	create_audio_player(
		"world",
		{
			"wind": ["res://Sound/wind.ogg", "./Sound/wind.ogg"],
			"trickster": ["res://Sound/mspa_harlequin.ogg", "./Sound/mspa_harlequin.ogg"]
		},
		true
	)
	create_audio_player(
			"piano",
			{
				"piano": ["res://Sound/afterthought-showtime_piano.ogg", "./Sound/afterthought-showtime_piano.ogg"]
		},
		true
	)
	get_tree().call_group("audio", "set_up_audio")


func get_current_room():
	return world.get_node("Scene/Room")


func open_dialog_box(dialog_id: String, num_of_pages: int):
	self.dialog_box.open_dialog_box(dialog_id, num_of_pages)
	if last_clicked_object:
		last_clicked_object.dialog_box_opened()
		last_clicked_object = null


func change_room(scene: String, spawn: String):
	num_interactive_elements_under_mouse = 0
	decrease_num_interactive_elements_under_mouse()
	self.world.load_room(scene, spawn)


func open_dialog_select(dialog_state: Array, prompts: Array):
	var dialogSelect = DialogSelect.instance()

	hud.add_child(dialogSelect)
	dialogSelect.init(dialog_state, prompts)


func close_dialog_select():
	if self.dialog_select:
		self.dialog_select.close()


func show_splashscreen(path: String, dialog_id: String, num_of_pages: int):
	splashscreen.show_splashscreen(path, dialog_id, num_of_pages)


func is_mouse_click(event: InputEvent):
	return event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT


func is_touch_tap(event: InputEvent):
	return event is InputEventScreenTouch and event.pressed
	# return event is InputEvent


func is_mouse_click_or_touch_tap_event(event: InputEvent):
	return is_mouse_click(event) or is_touch_tap(event)


func _process(delta):
	timer += delta


func increase_num_interactive_elements_under_mouse():
	match game_state:
		GAME_STATE.LOADING, GAME_STATE.CHANGE_ROOM:
			return
	num_interactive_elements_under_mouse += 1
	if num_interactive_elements_under_mouse > 0:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func decrease_num_interactive_elements_under_mouse():
	match game_state:
		GAME_STATE.LOADING, GAME_STATE.CHANGE_ROOM:
			return
	num_interactive_elements_under_mouse -= 1
	if num_interactive_elements_under_mouse <= 0:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		num_interactive_elements_under_mouse = 0


func has_enough_time_elapsed_since_state_change():
	return timer >= change_state_input_delay


func _input(event: InputEvent):
	if not (self.active and has_enough_time_elapsed_since_state_change()):
		return
	match self.game_state:
		GAME_STATE.INTERACT:
			last_clicked_object = null
			if not self.is_mouse_click_or_touch_tap_event(event) or dialog_box.closing_dialog_box:
				return

			get_tree().set_input_as_handled()
			click_position = get_global_mouse_position() if not is_touch_tap(event) else get_canvas_transform().xform_inv(event.position)
			
			if is_mobile and (dpad.pos_in_collision(event.position) or interact_button.pos_in_collision(event.position)):
				return

			if game_info_button.pos_in_collision(event.position):
				game_info_button.clicked()
				return

			var space_state = get_world_2d().direct_space_state
			var interactables = space_state.intersect_point(
				click_position, 32, [], 2147483647, false, true
			)
			for i in interactables:
				if i["collider"].get_parent().is_in_group("control"):
					return
			if (
				len(interactables) == 0
				or not interactables[-1]["collider"].get_parent().is_in_group("interactable")
			):
				return
			var clicked_object = interactables[-1]["collider"].get_parent()
			if clicked_object.has_method("dialog_box_opened"):
				last_clicked_object = clicked_object
			clicked_object.clicked()

		GAME_STATE.SELECT_DIALOG:
			if self.is_mouse_click(event):
				if self.mouse_in_text_select:
					self.dialog_select.process_click()
					get_tree().set_input_as_handled()
				else:
					self.dialog_select.close()
					self.mouse_in_text_select = false

		GAME_STATE.SPLASHSCREEN:
			if is_touch_tap(event):
				splashscreen._pressed()
		_:
			return


func load_data_from_file(path):
	var file = File.new()
	if not file.file_exists(path):
		print("File with room data not found: ", path)
		return
	file.open(path, File.READ)
	var parsed_json = JSON.parse(file.get_as_text())
	file.close()
	if parsed_json.error != OK:
		print(parsed_json.error_string, ", at ", parsed_json.error_line)
		return null

	var result = parsed_json.result
	return result
