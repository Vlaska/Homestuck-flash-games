extends Node2D


onready var camera = $Camera
onready var john = $Scene/Player/John


export(float) var FollowSpeed = 4.0


func dummy():
	print("dummy")


func _ready():
	TranslationServer.set_locale("pl")
	var dialogOptions = load("res://Dialog/DialogSelect.tscn")
	var tmp = dialogOptions.instance()
	tmp.init([tr("SPRITE_CLICKS_0_1"), " > TA DUŻA PLATFORMA. O RANY, CO TO JEST CHŁOPCZE?", " > test1dyhjtgtgtgtgtgtgt~\ngtgtgtgtgtgtgtgtgtg", " > test2dfgdbdf vbsfgv"], [funcref(self, "dummy"), funcref(self, "dummy"), funcref(self, "dummy"), funcref(self, "dummy")])
	# tmp.init(["SPRITE_CLICKS_0_1"], [funcref(self, "dummy")])
	get_node("/root/MainScene/Hud").add_child(tmp)
	tmp.rect_position = Vector2(200, 200)


func _process(_delta):
	var pos = john.global_position
	camera.position = camera.position.linear_interpolate(pos, _delta * FollowSpeed)
