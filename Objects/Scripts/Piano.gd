extends "res://Objects/Scripts/ObjectBase.gd"

var audio_player
var world_audio_player


func init(room_state: Dictionary, name: String, data: Dictionary):
	print(room_state[name])
	.init(room_state, name, data)
	self.add_to_group("audio")
	if not WorldController.is_browser or (WorldController.is_browser and WorldController.external_audio_menager_loaded):
		set_up_audio()
# audio_player = AudioStreamPlayer.new()
# audio_player.name = "Audio"
# self.add_child(audio_player)
# audio_player.stream = load("res://Sound/afterthought-showtime_piano.ogg")
# audio_player.autoplay = false
# audio_player.stream_paused = true


func set_up_audio():
	audio_player = WorldController.get_audio_player("piano")
	world_audio_player = WorldController.get_audio_player("world")


func _process(_delta):
	if world_audio_player.is_playing("trickster") and audio_player.is_playing("piano"):
		audio_player.stop_audio()


func dialog_box_opened():
	if not world_audio_player.is_playing("trickster"):
		if audio_player.is_playing("piano"):
			audio_player.stop_audio()
		audio_player.set_audio("piano", true)


func _exit_tree():
	audio_player.stop_audio()
	
