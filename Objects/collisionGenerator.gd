extends Node2D


onready var camera = $Camera2D2
var new_pos = Vector2.ZERO

func _ready():
	DialogController.active = false

func _process(delta):
	self.position = self.position.linear_interpolate(new_pos, 0.66 * delta)
# 	print(mou)
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		# print(event, " ", event.button_index)
	# if Input.is_action_pressed("RMB"):
		new_pos = self.get_local_mouse_position()