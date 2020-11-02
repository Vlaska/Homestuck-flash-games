extends HBoxContainer

var dialog_id: String
var num_of_pages

const TextBreak = preload("res://Dialog/Scripts/TextBreak.gd")

onready var textLabel = $TextLabel
onready var arrowLabel = $ArrowLabelContainer/ArrowLabel
var mouse_inside: bool = false
var total_character_count


func _ready():
	UpdateTimer.connect("timeout", self, "update")


func init(max_width: int, params: Dictionary, _dialog_state: Array):
	self.dialog_id = params["id"]
	self.num_of_pages = params.get("num_of_pages", 0)
	
	textLabel = $TextLabel
	arrowLabel = $ArrowLabelContainer/ArrowLabel
	# print(textLabel)
	self.set_text(max_width)
	self.textLabel.visible_characters = 0
	self.total_character_count = self.textLabel.get_total_character_count()


func set_text(max_width: int):
	var text = tr(self.dialog_id + "_0")
	var text_breaker = TextBreak.new(self.textLabel.get_font("font"))
	self.textLabel.text = text_breaker.format_text(text, max_width)


func _mouse_entered():
	mouse_inside = true
	self.textLabel.set("custom_colors/font_color", Color8(160, 160, 160))
	self.arrowLabel.set("custom_colors/font_color", Color8(160, 160, 160))
	
	
func _mouse_exited():
	mouse_inside = false
	self.textLabel.set("custom_colors/font_color", Color8(255, 255, 255))
	self.arrowLabel.set("custom_colors/font_color", Color8(255, 255, 255))


func clicked():
	WorldController.open_dialog_box(dialog_id, get_num_of_pages())


func update():
	self.textLabel.visible_characters += 1
	if self.textLabel.visible_characters >= self.total_character_count:
		UpdateTimer.disconnect("timeout", self, "update")


func get_num_of_pages():
	match typeof(num_of_pages):
		TYPE_REAL, TYPE_INT:
			return num_of_pages
		TYPE_DICTIONARY:
			var locale = TranslationServer.get_locale().split("_", true, 1)[0]
			if not (locale in num_of_pages):
				if not ("_" in num_of_pages):
					print("Locale ", locale, " not present in object dialog info.")
					return 0
				locale = "_"
			return num_of_pages[locale]

