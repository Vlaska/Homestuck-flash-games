extends "res://AudioPlayer.gd"

onready var audio_player = $AudioStreamPlayer
var currently_playing_audio: String = ""


func init(_files: Dictionary, _name: String, _loop: bool):
	var correct_paths = {}
	for i in _files:
		correct_paths[i] = _files[i][0]
	.init(correct_paths, _name, _loop)

func set_audio(audio_name: String, play: bool = true):
	audio_player.stream = load(self.files[audio_name])
	currently_playing_audio = audio_name
	if play:
		play_audio()
	
	
func play_audio():
	audio_player.play()
	audio_player.stream_paused = false


func resume_audio():
	audio_player.stream_paused = false


func pause_audio():
	audio_player.stream_paused = true


func stop_audio():
	audio_player.stop()
	audio_player.stream = null


func is_playing(audio_name: String = ""):
	if audio_name:
		if audio_name == currently_playing_audio:
			return not audio_player.stream_paused and audio_player.playing
		else:
			return false
	else:
		return not audio_player.stream_paused and audio_player.playing