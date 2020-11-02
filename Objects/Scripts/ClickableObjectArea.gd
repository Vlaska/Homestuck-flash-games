extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int):
	print("input event: ", self.get_parent().get_name())
	get_tree().set_input_as_handled()
