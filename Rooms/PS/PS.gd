extends "res://Rooms/RoomBase.gd"


func on_load():
	if WorldController.john.john_state == WorldController.john.JOHN_STATE.TRICKSTER:
		WorldController.john.turn_off_trickster_mode()
