extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"


var next: String
var index: int
var dialog_state: Array


func init(max_width: int, params: Dictionary, _dialog_state: Array, _label_index: int):
	.init(max_width, params, _dialog_state, _label_index)
	self.next = params["next"]
	self.index = params["index"]
	self.dialog_state = _dialog_state

func clicked():
	.clicked()
	self.dialog_state[self.index] = self.next

