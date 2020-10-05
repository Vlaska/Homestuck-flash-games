extends YSort


export(Vector2) var cameraHorizontalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraVerticalLimits = Vector2(-10000000.0, 10000000.0)
export(Vector2) var cameraZoom = Vector2(1, 1)


func _ready():
	var camera = get_node("/root/MainScene/Camera")
	camera.limit_left = cameraHorizontalLimits.x
	camera.limit_right = cameraHorizontalLimits.y
	camera.limit_top = cameraVerticalLimits.x
	camera.limit_bottom = cameraVerticalLimits.y
	camera.zoom = cameraZoom
