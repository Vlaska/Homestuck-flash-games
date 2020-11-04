extends PanelContainer

# var TextOption = preload("TextOption.gd")
const font = preload("res://Themes And Styles/DialogSelectFont.tres")
const TextBreak = preload("res://Dialog/Scripts/TextBreak.gd")
const BasicSelectLine = preload("res://Dialog/DialogSelectOptionBasic.tscn")
const ChangeSceneSelectLine = preload("res://Dialog/DialogSelectOptionChangeScene.tscn")
const SplashscreenSelectLine = preload("res://Dialog/DialogSelectOptionSplashscreen.tscn")
const SequenceSelectLine = preload("res://Dialog/DialogSelectOptionDialogSeq.tscn")
const CloseOption = preload("res://Dialog/DialogSelectOptionCloseDialogSelect.tscn")

var dialog_state: Array
var textBreak
var mouse_position
var viewport_size
var pos_in_hud
var num_of_text_options: int = 0

var index_of_selected_dialog_select: int


func _ready():
	font.set_size(WorldController.font_size)
	WorldController.dialog_select = self


func init(_dialog_state: Array, data: Array):
	WorldController.game_state = WorldController.GAME_STATE.SELECT_DIALOG

	var camera_zoom = get_node("/root/MainScene/Camera").zoom
	var viewport = get_viewport()

	dialog_state = _dialog_state
	# pos_in_hud = self.get_global_mouse_position()
	pos_in_hud = WorldController.click_position
	viewport_size = viewport.size

	self.rect_scale = camera_zoom
	self.rect_min_size = Vector2(viewport_size.x / 2, 0)
	mouse_position = viewport.get_mouse_position()

	var min_width = 0
	var tmp
	var textContainer = $Texts
	textBreak = TextBreak.new(font)
	var dialog_option_index = 0
	num_of_text_options = len(data)
	print(dialog_state)
	for j in range(num_of_text_options):
		var i = data[j]
		match i:
			{"sequence": var seq, "first": _}:
				var next_dialog = dialog_state[dialog_option_index]
				var dialog = seq[next_dialog]
				dialog["id"] = next_dialog
				dialog["index"] = dialog_option_index
				tmp = create_label(dialog, viewport_size.x, j)
				textContainer.add_child(tmp)
				dialog_option_index += 1
			_:
				tmp = create_label(i, viewport_size.x, j)
				textContainer.add_child(tmp)
		if min_width < tmp.rect_size.x:
			min_width = tmp.rect_size.x
	tmp = CloseOption.instance()
	tmp.init(viewport_size.x, {"id": "", "num_of_pages": 0}, dialog_state, num_of_text_options)
	tmp.connect("mouse_changed", self, "mouse_in_label_changed")
	textContainer.add_child(tmp)
	num_of_text_options += 1
	if min_width < tmp.rect_size.x:
		min_width = tmp.rect_size.x

	self.rect_min_size.x = min_width
	self.rect_position = pos_in_hud

	if self.rect_size.y + mouse_position.y >= viewport_size.y:
		self.rect_position.y += viewport_size.y - (self.rect_size.y + mouse_position.y)
	if self.rect_min_size.x + mouse_position.x + 1 >= viewport_size.x - 10:
		var t = pos_in_hud.x - self.rect_size.x - 1 + (viewport_size.x - mouse_position.x)
		self.rect_position.x = t
		if self.rect_position.x < 0:
			self.rect_position.x = 0
	
	if WorldController.is_mobile:
		index_of_selected_dialog_select = 0
		$Texts.get_child(index_of_selected_dialog_select).highlight_label_on()


func create_label(data: Dictionary, max_text_width: int, label_index: int):
	var tmp
	match data["action"]:
		"dialog":
			if "next" in data:
				tmp = SequenceSelectLine.instance()
			else:
				tmp = BasicSelectLine.instance()
		"splashscreen":
			tmp = SplashscreenSelectLine.instance()
		"change_scene":
			tmp = ChangeSceneSelectLine.instance()
	tmp.init(max_text_width, data, dialog_state, label_index)
	tmp.connect("mouse_changed", self, "mouse_in_label_changed")
	return tmp


func close():
	WorldController.mouse_in_text_select = false
	WorldController.dialog_select = null
	if WorldController.game_state == WorldController.GAME_STATE.SELECT_DIALOG:
		WorldController.game_state = WorldController.GAME_STATE.INTERACT
	queue_free()


func _mouse_entered():
	WorldController.mouse_in_text_select = true
	
func _mouse_exited():
	WorldController.mouse_in_text_select = false


func mouse_in_label_changed(index: int, is_inside: bool):
	if is_inside:
		if index_of_selected_dialog_select != -1:
			$Texts.get_child(index_of_selected_dialog_select).highlight_label_off()
		index_of_selected_dialog_select = index
	elif index_of_selected_dialog_select == index:
		index_of_selected_dialog_select = -1


func process_click():
	if index_of_selected_dialog_select != -1:
		$Texts.get_child(index_of_selected_dialog_select).clicked()
		self.close()


func _input(event: InputEvent):
	# print(event.to_string())
	if event.is_action_pressed("ui_up"):
		if index_of_selected_dialog_select == -1:
			index_of_selected_dialog_select = num_of_text_options - 1
		if index_of_selected_dialog_select - 1 >= 0:
			$Texts.get_child(index_of_selected_dialog_select).highlight_label_off()
			index_of_selected_dialog_select -= 1
			$Texts.get_child(index_of_selected_dialog_select).highlight_label_on()
	elif event.is_action_pressed("ui_down"):
		if index_of_selected_dialog_select == -1:
			index_of_selected_dialog_select = 0
		if index_of_selected_dialog_select + 1 < num_of_text_options:
			$Texts.get_child(index_of_selected_dialog_select).highlight_label_off()
			index_of_selected_dialog_select += 1
			$Texts.get_child(index_of_selected_dialog_select).highlight_label_on()
	elif event.is_action_pressed("interact"):
		process_click()
