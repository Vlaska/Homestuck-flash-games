extends Node

var files: Dictionary


func _ready():
	pass  # Replace with function body.


func init(_files: Dictionary, _name: String, _loop: bool):
	for i in _files:
		files[i] = _files[i]
	self.name = _name
	WorldController.add_child(self)


func set_audio(_path: String, _play: bool):
	pass


func play_audio():
	pass


func pause_audio():
	pass


func stop_audio():
	pass


func is_playing():
	pass
