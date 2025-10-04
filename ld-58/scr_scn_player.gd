class_name Player extends CharacterBody2D

enum Capturer {
	DIALOGUE = 0b1,
}

@onready var sprite: AnimatedSprite2D = $Sprite

@export var speed := 60.0

var _capturers := 0


func _ready() -> void:
	sprite.play()


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector(&"walk_left", &"walk_right", &"walk_up", &"walk_down")
	_process_movement(input)
	_process_animation(input)


func _process_movement(input: Vector2) -> void:
	if _capturers:
		input = Vector2.ZERO
	else:
		velocity = input * speed
		move_and_slide()


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
