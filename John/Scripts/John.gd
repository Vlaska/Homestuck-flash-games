extends KinematicBody2D

var spd = 7  # * 60 # speed

var vel = Vector2.ZERO

var prevVFacingDirection = 1  # 1 down, -1 up
var prevHFacingDirection = 1  # 1 right, -1 left

onready var sprite = $JohnSprite
onready var spriteAnimationPlayer = $JohnSprite/AnimationPlayer
onready var spriteAnimationTree = $JohnSprite/AnimationTree
onready var spriteAnimationState = spriteAnimationTree.get("parameters/State/playback")
onready var camera = get_node("/root/MainScene/Camera")
onready var input_area = $InputArea
onready var audio_player = $Audio

export(String, FILE, "*.json") var dialog_data_path = ""

var prefix_animation_name: String = ""

enum JOHN_STATE { NORMAL, TRICKSTER }
var john_state = JOHN_STATE.NORMAL

var dialog_state = []
var dialog_data: Array

signal trickster_mode(state)


func _ready():
	spriteAnimationTree.active = true
	UpdateTimer.connect("timeout", self, "update")
	dialog_data = WorldController.load_data_from_file(dialog_data_path)
	for i in dialog_data:
		match i:
			{"sequence": _, "first": var first}:
				dialog_state.append(first)


func update():
	spriteAnimationTree.advance(1)


func _physics_process(delta):
	match WorldController.game_state:
		WorldController.GAME_STATE.INTERACT:
			move_state(delta)
		_:
			return


func move_state(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if (input_vector == Vector2.ZERO):
		if Input.is_action_pressed("click") and WorldController.has_enough_time_elapsed_since_state_change():
			input_vector = get_local_mouse_position()
	input_vector = input_vector.normalized()

	if Input.is_action_just_pressed("trickster_mode_toggle"):
		toggle_trickster_mode()

	if input_vector != Vector2.ZERO:
		var h_direction_sign = sign(input_vector.x)
		var v_direction_sign = sign(input_vector.y)
		if v_direction_sign:
			if v_direction_sign != prevVFacingDirection:
				prevVFacingDirection = v_direction_sign
				vel.y *= -1

			spriteAnimationTree.set("parameters/State/Still/blend_position", input_vector.y)
			spriteAnimationTree.set("parameters/State/Walk/blend_position", input_vector.y)
			spriteAnimationTree.set("parameters/State/TricksterStill/blend_position", input_vector.y)
			spriteAnimationTree.set("parameters/State/TricksterWalk/blend_position", input_vector.y)

		if h_direction_sign:
			if h_direction_sign != prevHFacingDirection:
				prevHFacingDirection = h_direction_sign
				sprite.scale.x *= -1
				input_area.scale.x *= -1

		vel += (input_vector * spd / _delta) / 3.5

		spriteAnimationState.travel(prefix_animation_name + "Walk")
	else:
		vel = Vector2.ZERO
		spriteAnimationState.travel(prefix_animation_name + "Still")

	vel *= 0.8
	vel = move_and_slide(vel)


func toggle_trickster_mode():
	match john_state:
		JOHN_STATE.NORMAL:
			turn_on_trickster_mode()
		JOHN_STATE.TRICKSTER:
			turn_off_trickster_mode()
	emit_signal("trickster_mode", john_state)


func turn_off_trickster_mode():
	john_state = JOHN_STATE.NORMAL
	self.set_collision_layer_bit(0, true)
	self.set_collision_layer_bit(19, false)
	prefix_animation_name = ""
	self.scale.y *= -1
	# audio_player.stream_paused = true
	# audio_player.stop()
	# WorldController.disable_audio = false
	WorldController.get_audio_player("world").stop_audio()
	var room = WorldController.get_current_room()
	if room:
		room.set_audio()
	# WorldController.
	
	
func turn_on_trickster_mode():
	john_state = JOHN_STATE.TRICKSTER
	self.set_collision_layer_bit(0, false)
	self.set_collision_layer_bit(19, true)
	prefix_animation_name = "Trickster"
	self.scale.y *= -1
	# audio_player.stream_paused = false
	# audio_player.play()
	# WorldController.disable_audio = true
	WorldController.get_audio_player("world").set_audio("trickster")


func clicked():
	WorldController.open_dialog_select(dialog_state, dialog_data)


func _mouse_entered():
	WorldController.increase_num_interactive_elements_under_mouse()
	
	
func _mouse_exited():
	WorldController.decrease_num_interactive_elements_under_mouse()
