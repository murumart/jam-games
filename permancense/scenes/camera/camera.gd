extends Camera2D


func _physics_process(delta: float) -> void:
	var a := int(Input.is_action_pressed("ui_page_up"))
	var b := int(Input.is_action_pressed("ui_page_down"))
	
	if a: zoom += Vector2(delta, delta)
	if b:
		zoom -= Vector2(delta, delta)
		zoom = zoom.clamp(Vector2(0.1, 0.1), Vector2(32767, 32767)) 

