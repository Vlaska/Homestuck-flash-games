extends Label

onready var john = get_node("/root/MainScene/Scene/Player/John")


func clicked():
	john.toggle_trickster_mode()


func _mouse_entered():
	WorldController.increase_num_interactive_elements_under_mouse()
	
	
func _mouse_exited():
	WorldController.decrease_num_interactive_elements_under_mouse()
