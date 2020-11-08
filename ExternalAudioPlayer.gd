extends "res://AudioPlayer.gd"

var player_name: String
var currently_playing_audio: String = ""


func _ready():
	pass


func init(_files: Dictionary, _name: String, loop: bool):
	var paths = {}
	for i in _files:
		paths[i] = _files[i][1]
	.init({}, _name, loop)
	JavaScript.eval('new_audio_player("%s", %s, {loop: %s});' % [_name, JSON.print(paths), str(loop).to_lower()])


func set_audio(audio_name: String, play: bool = true):
	if currently_playing_audio != "":
		stop_audio()
	currently_playing_audio = audio_name
	if play:
		JavaScript.eval('play_audio("%s", "%s", false);' % [self.name, currently_playing_audio])
	


func is_playing(audio_name: String = ""):
	if audio_name:
		if audio_name == currently_playing_audio:
			return JavaScript.eval('is_playing("%s", "%s")' % [self.name, currently_playing_audio])
		else:
			return false
	else:
		return JavaScript.eval('is_playing("%s", "%s")' % [self.name, currently_playing_audio])


func play_audio():
	JavaScript.eval('play_audio("%s", "%s", true)' % [self.name, currently_playing_audio])


func resume_audio():
	JavaScript.eval('play_audio("%s", "%s", false)' % [self.name, currently_playing_audio])


func pause_audio():
	JavaScript.eval('pause_audio("%s", "%s")' % [self.name, currently_playing_audio])


func stop_audio():
	JavaScript.eval('stop_audio("%s", "%s");' % [self.name, currently_playing_audio])
	currently_playing_audio = ""


func _enter_tree():
	pass


func _exit_tree():
	pass
