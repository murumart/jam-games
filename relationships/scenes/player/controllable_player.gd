class_name ControllablePlayer extends Player

@export var input_enabled := true


func _handle_input() -> void:
	if not input_enabled:
		return
	if Input.is_action_pressed("jump") and state == States.FLOOR:
		_start_jump()
	if Input.is_action_just_released("jump"):
		_end_jump()
	_direction = Input.get_axis("move_left", "move_right")
