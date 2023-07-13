class_name Projectile extends Node2D

var direction := Vector2.RIGHT
@export var speed := 200
var time := 0.0


func _ready() -> void:
	$Hurtbox.hit.connect(
		queue_free
	)
	$WorldCollision.body_entered.connect(
		func(_no):
			direction = -direction
	)


func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed
	time += delta * 60
	if time > 300: queue_free()


