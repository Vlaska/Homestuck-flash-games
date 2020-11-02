extends Node2D

onready var camera = $Camera2D2
var new_pos = Vector2.ZERO


func _ready():
	WorldController.active = false


func _process(delta):
	self.position = self.position.linear_interpolate(new_pos, 0.66 * delta)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		new_pos = self.get_local_mouse_position()
