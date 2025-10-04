class_name Player extends CharacterBody2D

enum Capturer {
	DIALOGUE = 0x1,
	LEVEL_TRANSITION = 0x2,
}

static var extant: Player # evil singleton bullshit. only one player in scene tree ever

static var _last_animation: StringName
static var _last_flip: bool

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var inspect_trigger_area: Area2D = $InspectTriggerArea

@export var speed := 60.0

var _capturers := 0


func _ready() -> void:
	if _last_animation:
		sprite.animation = _last_animation
	sprite.flip_h = _last_flip
	sprite.play()


func _enter_tree() -> void:
	assert(extant == null)
	extant = self


func _exit_tree() -> void:
	_last_animation = sprite.animation
	_last_flip = sprite.flip_h
	extant = null


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector(&"walk_left", &"walk_right", &"walk_up", &"walk_down")
	_process_movement(input)
	_process_inspecting(input)
	_process_animation(input)


func _process_movement(input: Vector2) -> void:
	if _capturers:
		input = Vector2.ZERO
	else:
		velocity = input * speed
		move_and_slide()


func _process_inspecting(input: Vector2) -> void:
	if inspect_trigger_area.monitorable:
		inspect_trigger_area.monitorable = false
	if _capturers:
		return
	if Input.is_action_just_pressed(&"ui_accept"):
		inspect_trigger_area.monitorable = true

	if not input:
		return
	inspect_trigger_area.rotation = input.angle() + PI * 0.5


func _process_animation(input: Vector2) -> void:
	var vellen := velocity.length_squared() / (speed ** 2.0)
	sprite.speed_scale = vellen
	if vellen <= 0:
		sprite.frame = 0

	if _capturers:
		return
	if absf(input.x) > 0:
		sprite.animation = &"walk_side"
		sprite.flip_h = input.x < 0
	elif input.y > 0:
		sprite.animation = &"walk_front"
	elif input.y < 0:
		sprite.animation = &"walk_back"


func capture(capturer: Capturer) -> void:
	_capturers |= capturer


func release(capturer: Capturer) -> void:
	if capturer == 0:
		_capturers = 0
		return
	_capturers &= ~capturer
