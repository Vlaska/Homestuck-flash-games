extends TextureButton


class Test:
	var text: String
	var t: int


onready var sprite = $Sprite

# export(Array, FuncRef) var callbacks = []

# func _input(event):
	# if event is InputEventMouseButton:
		# print(event, " ", event.pressed, " ", event.is_echo(), " ", event.button_index)
	# if event is InputEventMouseButton and event.pressed and not event.is_echo() and event.button_index == BUTTON_LEFT:
	# 	var pos = sprite.position + sprite.offset - ((sprite.texture.get_size() / 2.0) if sprite.centered else Vector2.ZERO)
	# 	if Rect2(pos, sprite.texture.get_size()).has_point(event.position):
	# 		print("test")
	# 		get_tree().set_input_as_handled()


func openDialogSelect():
	pass
