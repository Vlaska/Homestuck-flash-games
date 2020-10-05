extends KinematicBody2D


var spd = 7# * 60 # speed

var vel = Vector2.ZERO

var prevVFacingDirection = 1 # 1 down, -1 up
var prevHFacingDirection = 1 # 1 right, -1 left

onready var sprite = $JohnSprite
onready var spriteAnimationPlayer = $JohnSprite/AnimationPlayer
onready var spriteAnimationTree = $JohnSprite/AnimationTree
onready var spriteAnimationState = spriteAnimationTree.get("parameters/State/playback")

var _scale = 1


func _ready():
	spriteAnimationTree.active = true
	get_node("/root/MainScene/UpdateTimer").connect("timeout", self, "update")


func update():
	spriteAnimationTree.advance(1)


func _physics_process(delta):
	move_state(delta)


func move_state(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

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
				emit_signal("flip_sprite")
		
		vel += (input_vector * spd / _delta) / (3.5 * _scale)
		
		spriteAnimationState.travel("Walk")
	# elif Input.action_press("LMB"):
	else:
		vel = Vector2.ZERO
		spriteAnimationState.travel("Still")
		
	vel *= 0.8
	vel = move_and_slide(vel)


func change_parent(new_parent):
	get_parent().call_deferred("remove_child", self)
	new_parent.call_deferred("add_child", self)