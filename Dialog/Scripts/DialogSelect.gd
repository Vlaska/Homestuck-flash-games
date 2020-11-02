extends PanelContainer

# var TextOption = preload("TextOption.gd")
const font = preload("res://Themes And Styles/DialogSelectFont.tres")
const TextBreak = preload("res://Dialog/Scripts/TextBreak.gd")
const BasicSelectLine = preload("res://Dialog/DialogSelectOptionBasic.tscn")
const ChangeSceneSelectLine = preload("res://Dialog/DialogSelectOptionChangeScene.tscn")
const SplashscreenSelectLine = preload("res://Dialog/DialogSelectOptionSplashscreen.tscn")
const SequenceSelectLine = preload("res://Dialog/DialogSelectOptionDialogSeq.tscn")
const CloseOption = preload("res://Dialog/DialogSelectOptionCloseDialogSelect.tscn")
var texts: Array = []
var dialog_state: Array
var textBreak
var mouse_position
var viewport_size
var pos_in_hud

var index_of_selected_dialog_select: int = -1


func _ready():
	font.set_size(get_node("/root/MainScene").font_size)
	WorldController.dialog_select = self


func init(_dialog_state: Array, data: Array, _pos_in_hud: Vector2):
	WorldController.game_state = WorldController.GAME_STATE.SELECT_DIALOG

	var camera_zoom = get_node("/root/MainScene/Camera").zoom
	var viewport = get_viewport()

	dialog_state = _dialog_state
	pos_in_hud = self.get_global_mouse_position()
	viewport_size = viewport.size

	self.rect_scale = camera_zoom
	self.rect_min_size = Vector2(viewport_size.x / 2, 0)
	mouse_position = viewport.get_mouse_position()

	var tmp
	var textContainer = $Texts
	textBreak = TextBreak.new(font)
	var dialog_option_index = 0
	for i in data:
		match i:
			{"sequence": var seq}:
				var next_dialog = dialog_state[dialog_option_index]
				var dialog = seq[next_dialog]
				dialog["id"] = next_dialog
				dialog["index"] = dialog_option_index
				tmp = create_label(dialog, viewport_size.x)
				textContainer.add_child(tmp)
				dialog_option_index += 1
			_:
				tmp = create_label(i, viewport_size.x)
				textContainer.add_child(tmp)
		texts.append(tmp)
	tmp = CloseOption.instance()
	tmp.init(viewport_size.x, {"id": "", "num_of_pages": 0}, dialog_state)
	texts.append(tmp)
	textContainer.add_child(tmp)

	var min_width = 0
	for i in texts:
		if min_width < i.rect_size.x:
			min_width = i.rect_size.x
	self.rect_min_size.x = min_width
	self.rect_position = pos_in_hud

	if self.rect_size.y + mouse_position.y >= viewport_size.y:
		self.rect_position.y += viewport_size.y - (self.rect_size.y + mouse_position.y)
	if self.rect_min_size.x + mouse_position.x + 1 >= viewport_size.x - 10:
		var t = pos_in_hud.x - self.rect_size.x - 1 + (viewport_size.x - mouse_position.x)
		self.rect_position.x = t
		if self.rect_position.x < 0:
			self.rect_position.x = 0


func create_label(data: Dictionary, max_text_width: int):
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
	tmp.init(max_text_width, data, dialog_state)
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


func process_click():
	for i in texts:
		if i.mouse_inside:
			i.clicked()
			self.close()
			return


func _process(_delta: float):
	if Input.is_action_just_pressed("ui_up"):
		pass
	elif Input.is_action_just_pressed("ui_down"):
		pass
