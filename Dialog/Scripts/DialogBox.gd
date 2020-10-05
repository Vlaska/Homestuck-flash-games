extends Node2D


onready var animationPlayer = $DialogBoxAnimationPlayer



func _process(_delta):
	#print(animationPlayer.assigned_animation, " ", animationPlayer.current_animation_position)
	if Input.is_action_just_pressed("ui_up"):
		animationPlayer.play("Closing")
	elif Input.is_action_just_pressed("ui_down"):
		animationPlayer.play("Opening")
	elif Input.is_action_just_pressed("ui_accept"):
		close_dialog_box()


func open_dialog_box():
	animationPlayer.play("Open")
	
	
func close_dialog_box():
	if animationPlayer.assigned_animation == "Open":
		animationPlayer.play("Closing")


func delete_dialog_box():
	#if not OS.is_debug_build():
	queue_free()
