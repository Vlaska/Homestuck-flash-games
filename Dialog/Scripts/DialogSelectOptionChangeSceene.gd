extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"


var scene: String
var spawn: String


func init(max_width: int, params: Dictionary, _dialog_state: Array):
	.init(max_width, params, _dialog_state)
	self.scene = params["scene"]
	self.spawn = params["spawn"]


func clicked():
	print("change scene")
	$"/root/MainScene".load_room(self.scene, self.spawn)

