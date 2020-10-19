extends Area2D


onready var camera = get_node("/root/MainScene/Camera")
var camera_follows: Node2D
onready var followed_position: Node2D = Node2D.new()

export(Vector2) var position_to_follow setget set_position_to_follow, get_position_to_follow


func set_position_to_follow(value):
	position_to_follow = value
	if followed_position:
		followed_position.position = value


func get_position_to_follow():
	return position_to_follow


func _ready():
	camera_follows = camera.follow_object
	self.add_child(followed_position)
	set_position_to_follow(position_to_follow)


func _body_entered(body: Node):
	print("Entered: ", body.name, " ", body == camera_follows)
	if body == camera_follows:
		camera.follow_object = followed_position
		
		
func _body_exited(body: Node):
	print("Exited: ", body.name, " ", body == camera_follows)
	if body == camera_follows:
		camera.set_default_follow_object()
