extends RichTextLabel


onready var font = self.get_font("font")
onready var space_width = font.get_string_size(" ").x
onready var dash_width = font.get_string_size("-").x


func split_word(word: String, width: int):
	if width <= 0:
		return ["", word]

	var left = 0
	var right = word.length()
	var mid = right >> 1
	var last_good_value = right
	for _i in range(50):
		if left == right:
			break
		var substring = word.substr(0, mid)
		var substring_width = font.get_string_size(substring).x
		if substring_width > width:
			right = mid - 1
			if mid < last_good_value:
				last_good_value = mid
		elif substring_width < width:
			left = mid + 1
			if mid > last_good_value:
				last_good_value = mid
		else:
			break
		mid = (left + right) >> 1
	if last_good_value == word.length():
		last_good_value = 0
	return [word.substr(0, last_good_value), word.substr(last_good_value)]


func break_word(word: String, width: int, max_width: int):
	if not word.length():
		return [word, 0]

	# space_width is for extra space in case if one character will land in next line,
	# then it will have more space in upper line
	var short_width = max_width - width - dash_width - space_width
	var splitted_word = split_word(word, short_width)
	var out = splitted_word[0]
	var reminder = splitted_word[1]

	if reminder.length() == 1:
		out += reminder
		reminder = ""
	elif out.length() == 1:
		reminder = out + reminder
		out = ""
	elif out != "" and reminder != "":
		out += "-"

	var reminder_width = font.get_string_size(reminder).x

	if reminder_width >= max_width:
		var tmp = break_word(reminder, 0, max_width)
		reminder = tmp[0]
		reminder_width = tmp[1]

	return [out + "\n" + reminder, reminder_width]


func _ready():
	self.set_process_input(true)
	# connect("input_event", self, "dummy")
	var max_width = self.rect_size.x
	var text = "Zażółć   gęślą jaźń ojghiogfddkjgbmnfxjnjndfjkmtdyuj."
	var t = ""
	for _i in range(5):
		t += text
		t += " "
	
	var lines = []
	for i in t.split("\n", true):
		lines.append(i.split(" ", true))

	var out = ""
	var current_line = 0

	while current_line < lines.size():
		var words = lines[current_line]
		var current_word = 0

		while current_word < words.size():
			var width = 0

			while width <= max_width:
				var word = words[current_word]
				var word_width = font.get_string_size(word).x
				current_word += 1

				if width + word_width + space_width <= max_width:
					width += word_width + space_width
					out += " " + word
				elif word_width < max_width:
					width = word_width
					out += "\n" + word
				else:
					var tmp = break_word(word, width, max_width)
					out += " " + tmp[0]
					width = tmp[1]
				
				if current_word >= words.size():
					break
		out += "\n"
		current_line += 1
	
	var clean_line = ""
	var tmp = out.split("\n", true)
	var final_num_of_lines = tmp.size()
	if final_num_of_lines:
		clean_line += tmp[0].strip_edges()
		for i in range(1, final_num_of_lines):
			clean_line += "\n" + tmp[i].strip_edges()
	
	# self.text = clean_line
	self.set_bbcode('[url={"action":"dialog", "dst":"test"}]' + clean_line + '[/url]')


	# self.text = t

# func _process(_delta):
	# print(self.get_minimum_size(), " ", self.rect_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# func _unhandled_input(event):
# 	print(event, " ", event.type)

func _on_Control_meta_hover_started(meta):
	print("enter ", meta)
	self.set("custom_colors/default_color", Color8(160,160,160))
	# pass
	
	
func _on_Control_meta_hover_ended(meta):
	print("exit ", meta)
	self.set("custom_colors/default_color", Color8(255, 255, 255))


func _on_Control_meta_clicked(meta):
	print("dummy ", meta, JSON.parse(meta).result)

