extends Sprite


const DialogSelect = preload("res://Dialog/DialogSelect.tscn")
var prompts: Array
var mouse_in_area = false
var dialog_state


func vecFromArray(arr: Array) -> Vector2:
	return Vector2(arr[0], arr[1])


func init(room_state: Dictionary, name: String, data: Dictionary):
	print("init ", name)
	self.name = name
	self.prompts = data["prompts"]
	# var img = Image.new()
	# var texture = ImageTexture.new()
	# print("img ", name, " ", img.load(data["sprite"]))
	# texture.create_from_image(img, 0) # turn off mipmaps, repeate and filter
	# print(texture, self.texture_normal)
	# self.set_normal_texture(texture)
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
	# collisionShape.position = img_size / 2
	# img.
	# self.connect("pressed", self, "openDialogSelect")


func openDialogSelect():
	print(self.get_name())


func set_collision_position(pos: Vector2):
	$CollisionArea.position = pos


func open_dialog_select():
	# if OS.has_feature("JavaScript"):
	# 	JavaScript.eval("console.log('" + self.get_name() + "');")
	# else:
	# 	print(self.get_name())
	var hud = get_node("/root/MainScene/Hud")
	var dialogSelect = DialogSelect.instance()
	var pos = hud.get_local_mouse_position()
	hud.add_child(dialogSelect)
	dialogSelect.init(self.dialog_state, prompts, pos)


func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		DialogController.sprite_clicked = true


func _on_CollisionArea_mouse_entered():
	mouse_in_area = true


func _on_CollisionArea_mouse_exited():
	mouse_in_area = false
