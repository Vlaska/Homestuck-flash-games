extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"


var next: String
var index: int
var dialog_state: Array


func init(max_width: int, params: Dictionary, _dialog_state: Array):
	.init(max_width, params, _dialog_state)
	self.next = params["next"]
	self.index = params["index"]
	self.dialog_state = dialog_state

func clicked():
	print("open sequence dialog")
	.clicked()
	self.dialog_state[self.index] = self.next

