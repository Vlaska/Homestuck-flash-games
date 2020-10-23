extends "res://Rooms/RoomBase.gd"


onready var animation_player = get_node("Sparks/AnimationPlayer")


func _ready():
	UpdateTimer.connect("timeout", self, "update")


func update():
	animation_player.advance(1.0)
