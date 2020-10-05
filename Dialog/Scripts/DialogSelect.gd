extends PanelContainer


var TextOption = preload("TextOption.gd")
var textOptions = []
onready var textContainer = $Texts
onready var timer = get_node("/root/MainScene/UpdateTimer")
var visible_characters = 0



# onready var panelContainer = $PanelContainer
# onready var mim_size = panelContainer.rect_size

func _ready():
	timer.connect("timeout", self, "update")


func init(options: Array, actions: Array):
	# var textContainer = $PanelContainer/Texts
	# var textContainer = $NinePatchRect/Texts
	# var textContainer = $MarginContainer/Texts
	var textContainer = $Texts
	for i in range(min(options.size(), actions.size())):
		var option = TextOption.new(options[i], actions[i])
		textOptions.append(option)
		var label = option.create_label()
		# print(label.text)
		# textContainer.get_parent().rect_min_size.x = label.rect_size.x
		textContainer.add_child(label)
	# panelContainer.rect_size = mim_size


func close():
	queue_free()

	
func button_pressed():
	print("test")


func openDialogBox():
	pass


func showSplashScreen():
	pass


func changeScene():
	pass


func update():
	var isDone = true
	visible_characters += 1
	for i in textContainer.get_children():
		i.set_visible_characters(visible_characters)
		isDone = isDone && (visible_characters >= i.get_total_character_count())
	if isDone:
		timer.disconnect("timeout", self, "update")
