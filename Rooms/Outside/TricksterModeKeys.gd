extends Label

onready var john = get_node("/root/MainScene/Scene/Player/John")


func clicked():
	john.toggle_trickster_mode()

