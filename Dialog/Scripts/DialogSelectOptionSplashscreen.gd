extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"

var path: String


func init(max_width: int, params: Dictionary, _dialog_state: Array, _label_index: int):
	.init(max_width, params, _dialog_state, _label_index)
	self.path = params["path"]


func clicked():
	WorldController.show_splashscreen(self.path, self.dialog_id, self.num_of_pages)
