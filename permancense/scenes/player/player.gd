class_name Player extends CharacterBody2D

var speed := 35
var friction := 400
var acceleration := 800

var input := Vector2()


func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	
	velocity = velocity.move_toward(Vector2(), friction * delta)
	if input: velocity = velocity.move_toward(input * speed, acceleration * delta)
	velocity = velocity.move_toward(velocity.round(), delta)
	
	move_and_slide()

