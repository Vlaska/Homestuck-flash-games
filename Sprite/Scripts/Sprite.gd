extends Node2D


onready var john = $"../John"
# onready var john = get_parent()
onready var spriteSprite = $SpriteSprite/AnimationPlayer


var dist = Vector2.ZERO
var displ = Vector2.ZERO
var artPos = Vector2.ZERO
var spritePos = Vector2.ZERO
var spriteFloat = 0
var prevHFacingDirection = 1 # 1 right, -1 left


# add scaling depending on scene height and width


func _ready():
	UpdateTimer.connect("timeout", self, "update")


func update():
	spriteSprite.advance(1)
	
	
func _process(_delta):
	spritePos = spritePos.linear_interpolate(john.position, 0.06666666)
	spriteFloat += 0.05
	self.position.x = spritePos.x
	self.position.y = spritePos.y + sin(spriteFloat) * 40

	var diff = spritePos.x - john.position.x
	if diff:
		self.scale.x = self.scale.y * sign(diff)
