extends Camera2D


export(float) var spd = 7
export(float) var zoom_factor = 0.05
var vel = Vector2.ZERO


func _process(delta):
    var input_vector = Vector2.ZERO
    input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
    input_vector = input_vector.normalized()

    if input_vector != Vector2.ZERO:
        vel += (input_vector * spd / delta) / (3.5)
    else:
        vel = Vector2.ZERO
    
    vel *= 0.8
    self.position += vel


func _input(event):
    if event is InputEventMouseButton:
        if event.pressed:
            match event.button_index:
                BUTTON_WHEEL_UP:
                    self.zoom -= Vector2(zoom_factor, zoom_factor)
                BUTTON_WHEEL_DOWN:
                    self.zoom += Vector2(zoom_factor, zoom_factor)
    