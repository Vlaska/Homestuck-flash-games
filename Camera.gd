extends Camera2D

export(float) var FollowSpeed = 4.0

var follow_object
export(NodePath) var default_follow_object


func _ready():
	self.set_default_follow_object()


func set_default_follow_object():
	self.follow_object = get_node(default_follow_object)


func _process(_delta):
	var pos = follow_object.global_position
	self.position = self.position.linear_interpolate(pos, _delta * FollowSpeed)
