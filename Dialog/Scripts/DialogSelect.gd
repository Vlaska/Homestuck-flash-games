extends PanelContainer

# var TextOption = preload("TextOption.gd")
const font = preload("res://Themes And Styles/DialogSelectFont.tres")
const TextBreak = preload("res://Dialog/Scripts/TextBreak.gd")
var textOptions = []
onready var textContainer = $Texts
var dialog_state: Array
var visible_characters = 0
var textBreak
var widths = []
var corrected = false
var mouse_position
var viewport_size
var pos_in_hud


func _ready():
	UpdateTimer.connect("timeout", self, "update")
	font.set_size(get_node("/root/MainScene").font_size)


func init(_dialog_state: Array, data: Array, _pos_in_hud: Vector2):
	var camera_zoom = get_node("/root/MainScene/Camera").zoom
	var viewport = get_viewport()
	dialog_state = _dialog_state
	pos_in_hud = self.get_global_mouse_position()
	viewport_size = viewport.size
	self.rect_scale = camera_zoom
	self.rect_min_size = Vector2(viewport_size.x / 2, 0)
	var max_text_width = int(viewport_size.x * 3 / 4)
	mouse_position = viewport.get_mouse_position()
	print(pos_in_hud, " ", mouse_position)

	if max_text_width >= viewport_size.x * 3 / 4:
		max_text_width = int(max_text_width)
	
	var _textContainer = $Texts
	# var tmp = RichTextLabel.new()
	# self.add_child(tmp)
	textBreak = TextBreak.new(font)
	# textBreak = TextBreak.new(tmp.get_font("font"))
	# tmp.queue_free()
	var dialog_option_index = 0
	for i in data:
		match i:
			{"sequence": var seq}:
				var next_dialog = dialog_state[dialog_option_index]
				var dialog = seq[next_dialog]
				dialog["id"] = next_dialog
				dialog["index"] = dialog_option_index
				_textContainer.add_child(create_label(dialog, viewport_size.x))
				dialog_option_index += 1
			_:
				_textContainer.add_child(create_label(i, viewport_size.x))
	var min_width = self.widths.max()
	self.rect_min_size.x = min_width
	self.rect_position = pos_in_hud

	# Force resize of container
	self.rect_size = Vector2(1, 1)

	if self.rect_size.y + mouse_position.y >= viewport_size.y:
		self.rect_position.y += viewport_size.y - (self.rect_size.y + mouse_position.y)
	# print(self.rect_min_size.x, " ", mouse_position.x, " ", self.rect_min_size.x + mouse_position.x, " ", viewport_size.y, " ", pos_in_hud.x)
	if self.rect_min_size.x + mouse_position.x + 1 >= viewport_size.x - 10:
		var t = pos_in_hud.x - self.rect_size.x - 1 + (viewport_size.x - mouse_position.x)
		# var t = pos_in_hud.x
		self.rect_position.x = t
		# print(t, " ")
		if self.rect_position.x < 0:
			self.rect_position.x = 0
		# pos_in_hud.x -= (self.rect_size.x + mouse_position.x) - viewport_size.x
		# self.rect_position.x -= self.rect_size.x - (viewport_size.x - mouse_position.x) + 3
	# print(mouse_position, " ", pos_in_hud)
	# for i in _textContainer.get_children():
	# 	i.get_node("Text").rect_size.x = min_width


func _process(_delta):
	if not corrected:
		viewport_size = null
		pos_in_hud = null
		mouse_position = null
		corrected = true
		

func create_label(data: Dictionary, max_text_width: int):
	var label = RichTextLabel.new()
	var text = tr(data["id"] + "_0")
	text = textBreak.format_text(text, max_text_width)
	var text_size = textBreak.font.get_string_size(text)
	self.widths.append(text_size.x)
	# var tmp = 
	label.bbcode_enabled = true
	label.set_bbcode("[url=" + JSON.print(data) + "]" + text + "[/url]")
	label.connect("meta_hover_started", self, "on_hover_over_label_started")
	label.connect("meta_hover_ended", self, "on_hover_over_label_ended")
	label.connect("meta_clicked", self, "label_clicked")
	label.set_visible_characters(0)
	label.set_process_input(true)
	label.size_flags_vertical = label.SIZE_EXPAND_FILL
	label.size_flags_horizontal = 0
	label.meta_underlined = false
	label.scroll_active = false
	label.name = "Text"
	
	var container = HBoxContainer.new()
	var arrow_label = Label.new()
	var tmp = VBoxContainer.new()
	arrow_label.text = ">"
	# container.add_child(arrow_label)
	tmp.add_child(arrow_label)
	container.add_child(tmp)
	container.add_child(label)
	# label.rect_size.x = max_text_width
	# print(textBreak.font.get_string_size(text), " ", text)
	container.set("custom_constants/separator", 10)
	# print(text_size, " ", text)
	label.rect_min_size.x = text_size.x
	label.rect_min_size.y = text_size.y * (text.split("\n", true).size() - 1)
	container.rect_min_size.y = text_size.y
	# label.rect_size.x = text_size.x
	# label.rect_size.y = text_size.y * (text.split("\n", true).size() - 1)
	
	# widths.append()
	# container.margin_left = 
	# return label
	return container


func close():
	DialogController.mouse_in_text_select = false
	queue_free()


func openDialogBox(dialog_id: String, num_of_pages: int):
	get_node("/root/MainScene/StaticHud/DialogBox").open_dialog_box(dialog_id, num_of_pages)


func showSplashScreen(path, num_of_pages, dialog_id):
	get_node("/root/MainScene/StaticHud/Splashscreen").show_splashscreen(path, dialog_id, num_of_pages)


func changeScene(room_name, spawn):
	$"/root/MainScene".load_room(room_name, spawn)


func on_hover_over_label_started(_meta):
	print("RichTextLabel: Mouse Entered")
	DialogController.mouse_in_text_select = true
	self.set("custom_colors/default_color", Color8(160,160,160))
	# pass
	
	
func on_hover_over_label_ended(_meta):
	print("RichTextLabel: Mouse Exited")
	DialogController.mouse_in_text_select = false
	self.set("custom_colors/default_color", Color8(255, 255, 255))


func get_num_of_pages(num_of_pages):
	print(num_of_pages, " ", typeof(num_of_pages), " ", TYPE_INT, " ", TYPE_DICTIONARY)
	match typeof(num_of_pages):
		TYPE_REAL, TYPE_INT:
			return num_of_pages
		TYPE_DICTIONARY:
			var locale = TranslationServer.get_locale().split("_", true, 1)[0]
			print(locale)
			if not (locale in num_of_pages):
				print("Locale ", locale, " not present in object dialog info.")
				return 0
			return num_of_pages[locale]
			


func label_clicked(meta):
	var data = JSON.parse(meta).result
	if data:
		print(data)
		match data:
			{"action": "dialog", "num_of_pages": var num_of_pages, "next": var next, "id": var dialog_id, "index": var index}:
				self.dialog_state[index] = next
				openDialogBox(dialog_id, get_num_of_pages(num_of_pages))
			{"action": "dialog", "num_of_pages": var num_of_pages, "id": var dialog_id}:
				openDialogBox(dialog_id, get_num_of_pages(num_of_pages))
			{"action": "splashscreen", "path": var path, "num_of_pages": var num_of_pages, "id": var dialog_id}:
				showSplashScreen(path, num_of_pages, dialog_id)
			{"action": "change_scene", "scene": var scene, "spawn": var spawn, "id": var _dialog_id}:
				changeScene(scene, spawn)
	#print(data)
	self.close()


func update():
	var isDone = true
	visible_characters += 1
	var textNode
	for i in textContainer.get_children():
		textNode = i.get_node("Text")
		textNode.set_visible_characters(visible_characters)
		isDone = isDone && (visible_characters >= textNode.get_total_character_count())
	if isDone:
		UpdateTimer.disconnect("timeout", self, "update")


func _mouse_entered():
	print("DialogSelect: Mouse Entered")
	DialogController.mouse_in_text_select = true
	
func _mouse_exited():
	print("DialogSelect: Mouse Exited")
	DialogController.mouse_in_text_select = false
