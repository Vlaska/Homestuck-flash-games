extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"


var scene: String
var spawn: String


func init(max_width: int, params: Dictionary, _dialog_state: Array, _label_index: int):
	.init(max_width, params, _dialog_state, _label_index)
	self.scene = params["scene"]
	self.spawn = params["spawn"]


func clicked():
	WorldController.change_room(self.scene, self.spawn)

