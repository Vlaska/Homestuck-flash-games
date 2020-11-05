extends "res://Objects/Scripts/ObjectBase.gd"


onready var shape = $CollisionArea/Shape

export(String, FILE, "*.json") var room_data_path = ""
var vert = []
var room_data: Dictionary
var current_object: Dictionary
var current_object_index = 0
var object_name_list: Array
var all_done: bool = false


func _ready():
	var file = File.new()
	if not file.file_exists(room_data_path):
		print("File with room data not found: ", room_data_path)
		return
	file.open(room_data_path, File.READ)
	room_data = JSON.parse(file.get_as_text()).result
	file.close()
	object_name_list = self.room_data["objects"].keys()
	load_new_object()


func load_new_object():
	if current_object_index >= object_name_list.size():
		finalize()
		return
	var current_object_name = object_name_list[current_object_index]
	current_object = room_data["objects"][current_object_name]
	current_object_index += 1
	OS.set_window_title(current_object_name)
	var texture = load(current_object["sprite"])
	if not texture:
		print("Texture missing: " + current_object["sprite"])
	self.texture = texture
	if not ("collisions" in current_object):
		self.vert = []
		self.shape.polygon = PoolVector2Array()
	else:
		self.vert = current_object["collisions"]
		var polygon = PoolVector2Array()
		for i in self.vert:
			polygon.append(vecFromArray(i))
		self.shape.polygon = polygon

func finalize():
	var file = File.new()
	var path = room_data_path
	# if not ("_collisions.json" in path):
	# 	var re = RegEx.new()
	# 	re.compile(".*?\\.json")
	# 	path = re.search(room_data_path).get_string() + "_collisions.json"
	file.open(path, File.WRITE)
	file.store_string(JSON.print(room_data))
	file.close()
	get_tree().quit()


func done():
	self.current_object["collisions"] = vert
	load_new_object()


func _process(_delta):
	if Input.is_action_just_pressed("undo"):
		var index = vert.size()
		if index:
			vert.pop_back()
			var tmp = self.shape.polygon
			tmp.remove(index - 1)
			self.shape.polygon = tmp
			# self.shape.polygon.remove(index - 1)
	elif Input.is_action_just_pressed("done"):
		done()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		# var pos = (event as InputEventMouseButton).position
		var pos = self.get_local_mouse_position()
		vert.append([pos.x, pos.y])
		var tmp = self.shape.polygon
		tmp.append(pos)
		self.shape.polygon = tmp
