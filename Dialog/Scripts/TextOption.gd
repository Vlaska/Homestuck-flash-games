extends Reference


class_name TextOption

var text: String = ""
var action: FuncRef = null

func _init(_text: String, _action: FuncRef):
	self.text = _text
	self.action = _action

func create_label():
	# var label = RichTextLabel.new()
	var label = Label.new()
	label.text = self.text
	# label.set_bbcode(self.text)
	label.connect("meta_clicked", self, "run_action")
	label.size_flags_horizontal = label.SIZE_EXPAND_FILL
	label.size_flags_vertical = label.SIZE_EXPAND_FILL
	label.set_visible_characters(0)
	label.set_process_input(true)
	# label.rect_min_size = Vector2(1000000, 1000000)
	return label

func run_action():
	self.action.call_func()
