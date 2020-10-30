extends KinematicBody2D

var spd = 7  # * 60 # speed

var vel = Vector2.ZERO

var prevVFacingDirection = 1  # 1 down, -1 up
var prevHFacingDirection = 1  # 1 right, -1 left

# export(NodePath) var joystick_path

onready var sprite = $JohnSprite
onready var spriteAnimationPlayer = $JohnSprite/AnimationPlayer
onready var spriteAnimationTree = $JohnSprite/AnimationTree
onready var spriteAnimationState = spriteAnimationTree.get("parameters/State/playback")
onready var camera = get_node("/root/MainScene/Camera")
onready var item_vision_area = $ItemVision
# onready var joystick = get_node(joystick_path)

# shoud be squared
const DEADZONE = 25

var trickster_mode_active = false

var _scale = 1
var is_touched = false
var touchPosition = Vector2.ZERO


func _ready():
	spriteAnimationTree.active = true
	UpdateTimer.connect("timeout", self, "update")


func update():
	spriteAnimationTree.advance(1)


func _physics_process(delta):
	move_state(delta)


func move_state(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if (
		input_vector == Vector2.ZERO
		and not (DialogController.input_handled or DialogController.mouse_in_dialog_box)
	):
		if Input.is_action_pressed("click"):
			input_vector = get_local_mouse_position()
		# elif joystick.is_working:
		# 	input_vector = joystick.output
	input_vector = input_vector.normalized()

	if Input.is_action_just_pressed("trickster_mode_toggle"):
		self.trickster_mode_active = not self.trickster_mode_active
		self.change_character_state()

	if input_vector != Vector2.ZERO:
		var h_direction_sign = sign(input_vector.x)
		var v_direction_sign = sign(input_vector.y)
		if v_direction_sign:
			if v_direction_sign != prevVFacingDirection:
				prevVFacingDirection = v_direction_sign
				vel.y *= -1

			spriteAnimationTree.set("parameters/State/Still/blend_position", input_vector.y)
			spriteAnimationTree.set("parameters/State/Walk/blend_position", input_vector.y)

		if h_direction_sign:
			if h_direction_sign != prevHFacingDirection:
				prevHFacingDirection = h_direction_sign
				sprite.scale.x *= -1

		vel += (input_vector * spd / _delta) / (3.5 * _scale)
		item_vision_area.rotation_degrees = (input_vector.angle() * 180.0 / PI) - 90

		spriteAnimationState.travel("Walk")
	else:
		vel = Vector2.ZERO
		spriteAnimationState.travel("Still")

	vel *= 0.8
	vel = move_and_slide(vel)


# func _input(event):
# 	var tmp = event is InputEventSingleScreenTouch
# 	if tmp or event is InputEventSingleScreenDrag or event is InputEventSingleScreenTap:
# 		touchPosition = get_local_mouse_position()
# 	if tmp:
# 		is_touched = event.pressed


func change_parent(new_parent):
	get_parent().call_deferred("remove_child", self)
	new_parent.call_deferred("add_child", self)


func change_character_state():
	if trickster_mode_active:
		self.set_collision_layer_bit(0, false)
		self.set_collision_layer_bit(19, true)
	else:
		self.set_collision_layer_bit(0, true)
		self.set_collision_layer_bit(19, false)


var objects_in_reach = {}


func item_vision_area_entered(area: Area2D):
	var parent = area.get_parent()
	objects_in_reach[parent.get_name()] = parent
	print("Area entered: ", area.get_parent().get_name())
	print(objects_in_reach)
	
	
func item_vision_area_exited(area: Area2D):
	var parent = area.get_parent()
	objects_in_reach.erase(parent.get_name())
	print("Area exited: ", area.get_parent().get_name())
	print(objects_in_reach)
		