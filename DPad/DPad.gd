extends Node2D


onready var collision = $IgnoreTouchArea/Shape
var size: Vector2

func _ready():
	size = collision.shape.extents * 2


func pos_in_collision(pos: Vector2) -> bool:
	return Rect2(collision.get_global_position() - collision.shape.extents, size).has_point(pos)

