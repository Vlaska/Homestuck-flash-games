extends Sprite


const DialogSelect = preload("res://Dialog/DialogSelect.tscn")
onready var world = get_node("/root/MainScene")
onready var collision = $CollisionArea
var prompts: Array
var mouse_in_area = false
var dialog_state


func vecFromArray(arr: Array) -> Vector2:
	return Vector2(arr[0], arr[1])


func init(room_state: Dictionary, name: String, data: Dictionary):
	# print("init ", name)
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


func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT and mouse_in_area:
		# print(get_name())
		WorldController.sprite_clicked = true


func _on_CollisionArea_mouse_entered():
	mouse_in_area = true
	
	
func _on_CollisionArea_mouse_exited():
	mouse_in_area = false


func clicked():
	WorldController.open_dialog_select(dialog_state, prompts)
