extends "res://Objects/Scripts/ObjectBase.gd"

var audio_player


func init(room_state: Dictionary, name: String, data: Dictionary):
    print(room_state[name])
    .init(room_state, name, data)
    audio_player = AudioStreamPlayer.new()
    audio_player.name = "Audio"
    self.add_child(audio_player)
    audio_player.stream = load("res://Sound/afterthought-showtime_piano.ogg")
    audio_player.autoplay = false
    audio_player.stream_paused = true


func _process(_delta):
    if WorldController.john.audio_player.playing and audio_player.playing:
        audio_player.stop()


func dialog_box_opened():
    print("PLAY AUDIO!!!")
    audio_player.stream_paused = false
    audio_player.play()
