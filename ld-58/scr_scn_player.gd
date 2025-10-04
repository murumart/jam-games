extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite

@export var speed := 60.0


func _ready() -> void:
	sprite.play()


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector(&"walk_left", &"walk_right", &"walk_up", &"walk_down")
	velocity = input * speed
	move_and_slide()

	if absf(input.x) > 0:
		sprite.animation = &"walk_side"
		sprite.flip_h = input.x < 0
	elif input.y > 0:
		sprite.animation = &"walk_front"
	elif input.y < 0:
		sprite.animation = &"walk_back"

	var vellen := velocity.length_squared() * 0.0005
	sprite.speed_scale = vellen
	if vellen <= 0:
		sprite.frame = 0
