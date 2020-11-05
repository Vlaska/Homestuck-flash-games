extends Sprite


const DialogSelect = preload("res://Dialog/DialogSelect.tscn")
onready var world = get_node("/root/MainScene")
onready var collision = $CollisionArea
var prompts: Array
var dialog_state


func vecFromArray(arr: Array) -> Vector2:
	return Vector2(arr[0], arr[1])


func init(room_state: Dictionary, name: String, data: Dictionary):
	self.name = name
	self.prompts = data["prompts"]
	var img = load(data["sprite"])
	if not img:
		print("Can't load texture: ", data["sprite"])
	self.texture = img
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
