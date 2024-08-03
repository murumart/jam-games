class_name CopyPlayer extends Player

@export var copy_from: ControllablePlayer
@export var copy_properties: Array[StringName] = []
@export var flip_numerics: Array[StringName] = []
@export var copy_states := false
@export var copy_only_when_equal_states := false
@export var copy_movement := false
@export var copy_jumps := false


func _physics_process(delta: float) -> void:
	if not is_instance_valid(copy_from):
		super(delta)
		return
	
	if copy_only_when_equal_states:
		if not state == copy_from.state:
			super(delta)
			return
	if copy_states:
		state = copy_from.state
	for c in copy_properties:
		var path := NodePath(c)
		set_indexed(path, copy_from.get_indexed(path))
	for c in flip_numerics:
		var path := NodePath(c)
		var value = get_indexed(path)
		if value is bool:
			value = not value
		else:
			value = -value
		set_indexed(path, value)
	super(delta)


func _handle_input() -> void:
	if not is_instance_valid(copy_from):
		return
	if copy_jumps:
		if Input.is_action_pressed("jump") and state == States.FLOOR:
			_start_jump()
		if Input.is_action_just_released("jump"):
			_end_jump()
	if copy_movement:
		_direction = Input.get_axis("move_left", "move_right")
