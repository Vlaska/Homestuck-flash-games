extends TextureButton


onready var dialog_box = get_node("/root/MainScene/StaticHud/DialogBox")
onready var room_transition = get_node("/root/MainScene/StaticHudWholeScreen/RoomTransition/AnimationPlayer")
var dialog_id: String
var num_of_pages: int

enum {
	OPEN_DIALOG_HIDDEN,
	OPEN_DIALOG_SHOWN,
	CLOSED
}

var state = CLOSED


func _ready():
	dialog_box.connect("dialog_box_closed", self, "hide_splashscreen")
	self.visible = false


func show_splashscreen(path: String, _dialog_id: String, _num_of_pages: int):
	self.texture_normal = load(path)
	self.visible = true
	state = OPEN_DIALOG_HIDDEN
	self.mouse_filter = self.MOUSE_FILTER_STOP
	self.dialog_id = _dialog_id
	self.num_of_pages = _num_of_pages
	self.room_transition.play("HideBg")
	WorldController.game_state = WorldController.GAME_STATE.SPLASHSCREEN
	


func open_dialog():
	if num_of_pages:
		dialog_box.open_dialog_box(dialog_id, num_of_pages)
		state = OPEN_DIALOG_SHOWN
	else:
		hide_splashscreen()


func hide_splashscreen():
	if state != CLOSED:
		self.visible = false
		state = CLOSED
		self.mouse_filter = self.MOUSE_FILTER_IGNORE
		self.room_transition.play("Empty")
		WorldController.game_state = WorldController.GAME_STATE.INTERACT


func _pressed():
	if state == OPEN_DIALOG_HIDDEN:
		open_dialog()
