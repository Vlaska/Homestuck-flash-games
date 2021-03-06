extends Node2D

onready var animationPlayer = $DialogBoxAnimationPlayer
onready var text = $Text
const TextBreak = preload("res://Dialog/Scripts/TextBreak.gd")
var dialog_id: String
var num_of_pages: int
var current_page: int = 1
var playing: bool = false
var dialog_box_is_open: bool = false
var closing_dialog_box: bool = false
signal dialog_box_closed


func _ready():
	UpdateTimer.connect("timeout", self, "update")
	dialog_box_is_closed()


func set_page():
	if self.current_page <= self.num_of_pages:
		self.text.text = tr(self.dialog_id + "_" + String(self.current_page))
		self.text.visible_characters = 0
		self.current_page += 1
	else:
		self.close_dialog_box()


func _input(event: InputEvent):
	if WorldController.is_mouse_click_or_touch_tap_event(event):
		var total_character_count = self.text.get_total_character_count()
		if self.text.visible_characters >= total_character_count:
			set_page()
		else:
			self.text.visible_characters = total_character_count

	
func open_dialog_box(_dialog_id: String, _num_of_pages: int):
	if _num_of_pages <= 0:
		return
	animationPlayer.play("Opening")
	self.visible = true
	self.playing = true
	self.dialog_box_is_open = true
	self.current_page = 1
	self.dialog_id = _dialog_id
	self.num_of_pages = _num_of_pages
	WorldController.game_state = WorldController.GAME_STATE.DIALOG
	set_page()


func close_dialog_box():
	if animationPlayer.assigned_animation == "Open":
		animationPlayer.play("Closing")
		self.dialog_box_is_open = false
		self.closing_dialog_box = true
		WorldController.game_state = WorldController.GAME_STATE.INTERACT


func dialog_box_is_closed():
	self.visible = false
	self.playing = false
	self.closing_dialog_box = false
	emit_signal("dialog_box_closed")


func update():
	if self.playing:
		animationPlayer.advance(1.0)
	if self.dialog_box_is_open:
		text.visible_characters += 1

func mouse_entered():
	WorldController.mouse_in_dialog_box = true
	
	
func mouse_exited():
	WorldController.mouse_in_dialog_box = false
