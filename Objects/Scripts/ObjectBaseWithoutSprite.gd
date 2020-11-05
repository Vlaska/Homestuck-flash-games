extends Node2D


const DialogSelect = preload("res://Dialog/DialogSelect.tscn")
onready var world = get_node("/root/MainScene")
onready var collision = $CollisionArea
var prompts: Array
var dialog_state
var offset setget set_offset, get_offset


func _ready():
	offset = Vector2.ZERO


func set_offset(value: Vector2):
	self.position -= offset if offset else Vector2.ZERO
	offset = value
	self.position += offset


func get_offset():
	return offset


func vecFromArray(arr: Array) -> Vector2:
	return Vector2(arr[0], arr[1])


func init(room_state: Dictionary, name: String, data: Dictionary):
	self.name = name
	self.prompts = data["prompts"]
	var collisionShape = $CollisionArea/Shape
	var polygon = collisionShape.polygon
	for i in data["collisions"]:
		polygon.append(vecFromArray(i))
	collisionShape.polygon = polygon
	self.dialog_state = room_state[name]


func set_collision_position(pos: Vector2):
	$CollisionArea.position = pos


func clicked():
	WorldController.open_dialog_select(dialog_state, prompts)


func _mouse_entered():
	WorldController.increase_num_interactive_elements_under_mouse()
	
	
func _mouse_exited():
	WorldController.decrease_num_interactive_elements_under_mouse()
