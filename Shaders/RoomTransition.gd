extends ColorRect


onready var mainScene = get_node("/root/MainScene")
onready var animation_player = get_node("AnimationPlayer")


func fade_in_finished():
	mainScene.change_room()
