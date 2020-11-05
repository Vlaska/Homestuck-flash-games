extends Node2D

var is_bobbling: bool = true
onready var bobble_animation_player = $AnimationPlayer
onready var dialog_box_bubble = $InputArea/BoobleOn
onready var dialog_box = $InputArea/BoobleOff
onready var dialog_box_bubble_size = $InputArea/BoobleOn.shape.extents * 2
onready var dialog_box_size = $InputArea/BoobleOff.shape.extents * 2

const DISTANCE_FROM_RIGHT_EDGE_OF_THE_SCREEN = 64.55


func _ready():
	UpdateTimer.connect("timeout", self, "update")
	get_viewport().connect("size_changed", self, "offset_position")
	offset_position()
	if WorldController.is_mobile:
		$GameInfoDialogBox/Panel/Label.text = "GAME_INFO_TAP_HERE"


func clicked():
	WorldController.open_dialog_box("GAME_INFO_TEXT", 1)
	if is_bobbling:
		$InputArea/BoobleOn.disabled = true
		$GameInfoDialogBox.visible = false
		UpdateTimer.disconnect("timeout", self, "update")
		is_bobbling = false


func update():
	bobble_animation_player.advance(1)


func check_if_mouse_inside(pos: Vector2):
	var space_state = get_world_2d().direct_space_state
	print(space_state.intersect_point(
		pos, 32, [], 2147483647, false, true
	))


func pos_in_collision(pos: Vector2) -> bool:
	return Rect2(dialog_box.get_global_position() - dialog_box.shape.extents, dialog_box_size).has_point(pos) or (
		is_bobbling and 
		Rect2(dialog_box_bubble.get_global_position() - dialog_box_bubble.shape.extents, dialog_box_bubble_size).has_point(pos)
	)


func offset_position():
	self.position.x = get_viewport().size.x - DISTANCE_FROM_RIGHT_EDGE_OF_THE_SCREEN


func _mouse_entered():
	WorldController.increase_num_interactive_elements_under_mouse()
	
	
func _mouse_exited():
	WorldController.decrease_num_interactive_elements_under_mouse()
