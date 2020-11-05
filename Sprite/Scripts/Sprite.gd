extends Node2D


onready var john = $"../John"
# onready var john = get_parent()
onready var spriteSprite = $SpriteSprite/AnimationPlayer
onready var spriteDialogBox = $DialogBox/AnimationPlayer


var dist = Vector2.ZERO
var displ = Vector2.ZERO
var artPos = Vector2.ZERO
var spritePos = Vector2.ZERO
var spriteFloat = 0
var prevHFacingDirection = 1 # 1 right, -1 left

export(String, FILE, "*.json") var dialog_data_path = ""


var dialog_state = []
var dialog_data: Array


func _ready():
	UpdateTimer.connect("timeout", self, "update")
	john.connect("trickster_mode", self, "toggle_trickster_mode")
	dialog_data = WorldController.load_data_from_file(dialog_data_path)
	for i in dialog_data:
		match i:
			{"sequence": _, "first": var first}:
				dialog_state.append(first)


func update():
	spriteSprite.advance(1)
	spriteDialogBox.advance(1)
	
	
func _process(_delta):
	spritePos = spritePos.linear_interpolate(john.position, 0.06666666)
	spriteFloat += 0.05
	self.position.x = spritePos.x
	self.position.y = spritePos.y + sin(spriteFloat) * 40

	var diff = spritePos.x - john.position.x
	if abs(diff) >= 0.5:
		self.scale.x = self.scale.y * sign(diff)


func clicked():
	WorldController.open_dialog_select(dialog_state, dialog_data)


func dialog_box_opened():
	spriteDialogBox.play("DialogBox")


func toggle_trickster_mode(state):
	match state:
		john.JOHN_STATE.NORMAL:
			spriteSprite.play("Sprite")
		john.JOHN_STATE.TRICKSTER:
			spriteSprite.play("Trickster")


func _mouse_entered():
	WorldController.increase_num_interactive_elements_under_mouse()
	
	
func _mouse_exited():
	WorldController.decrease_num_interactive_elements_under_mouse()
