extends TouchScreenButton


onready var collision = $IgnoreTouchArea/Shape
onready var icon_size = self.normal.get_size()
export(float) var offset_from_edge: float = 15.0 setget set_offset_from_edge
var radius: float
var initialized = false


func _ready():
	get_viewport().connect("size_changed", self, "offset_position")
	initialized = true
	radius = collision.shape.radius
	radius *= radius
	offset_position()


func set_offset_from_edge(value: float):
	offset_from_edge = value
	if initialized:
		offset_position()


func offset_position():
	self.position.x = get_viewport().size.x - (offset_from_edge + icon_size.x)


func pos_in_collision(pos: Vector2) -> bool:
	return collision.get_global_position().distance_squared_to(pos) <= radius
