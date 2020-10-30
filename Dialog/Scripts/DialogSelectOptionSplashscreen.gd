extends "res://Dialog/Scripts/DialogSelectOptionBasic.gd"

var path: String


func init(max_width: int, params: Dictionary, _dialog_state: Array):
	.init(max_width, params, _dialog_state)
	self.path = params["path"]


func clicked():
	print("open splashscreen")
	$"/root/MainScene/StaticHud/Splashscreen".show_splashscreen(self.path, self.dialog_id, self.num_of_pages)
