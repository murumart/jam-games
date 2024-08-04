class_name Player extends CharacterBody2D

enum States {FLOOR, JUMP, FALL, FREEZE}

const SPEED = 120.0
const JUMP_VELOCITY = -300.0
const JUMP_GRAV_MULT := 0.5
const GROUND_ACCEL := 1920.0
const AIR_ACCEL := 720.0

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var state := States.FALL
var _direction := 0.0

@export var sprite: Sprite2D


func _physics_process(delta: float) -> void:
	if state == States.FREEZE:
		return
	
	_sprite_animation()
	if state == States.FALL:
		velocity.y += gravity * delta
	elif state == States.JUMP:
		velocity.y += gravity * JUMP_GRAV_MULT * delta

	_handle_input()
	
	if state == States.FLOOR:
		velocity.x = move_toward(velocity.x, _direction * SPEED, delta * GROUND_ACCEL)
	elif state == States.FALL or state == States.JUMP:
		velocity.x = move_toward(velocity.x, _direction * SPEED, delta * AIR_ACCEL)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var collider := collision.get_collider()
		if not collider is CharacterBody2D:
			continue
		var normal := collision.get_normal()
		collider.velocity -= normal * SPEED * maxf(velocity.length() * 0.005, 0.5)
	
	if is_on_floor():
		state = States.FLOOR
	else:
		state = States.FALL
	_prev_velocity = velocity


func _handle_input() -> void:
	pass


func _start_jump() -> void:
	velocity.y = JUMP_VELOCITY
	state = States.JUMP


func _end_jump() -> void:
	velocity.y = maxf(0.0, velocity.y)
	state = States.FALL


var _prev_velocity := Vector2()
func _sprite_animation() -> void:
	if not is_instance_valid(sprite):
		return
	var change := _prev_velocity - velocity
	sprite.scale.x = remap(change.y, 0, 2000, 1.0, 0.55)
