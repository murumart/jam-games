class_name Player extends CharacterBody2D

var speed := 35
var friction := 400
var acceleration := 800
@onready var anim: AnimatedSprite2D = $Sprite2D

var locked := false
var input := Vector2()


func _ready() -> void:
	GUI.dial_opened.connect(func(): locked = true)
	GUI.dial_closed.connect(func(): locked = false)


func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	
	velocity = velocity.move_toward(Vector2(), friction * delta)
	if input: velocity = velocity.move_toward(input * speed, acceleration * delta)
	velocity = velocity.move_toward(velocity.round(), delta)
	anim.speed_scale = velocity.length() * 0.05
	
	if not locked:
		move_and_slide()

