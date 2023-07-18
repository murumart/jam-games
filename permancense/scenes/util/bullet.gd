class_name Bullet extends RayCast2D

@export var speed := 200.0
var life := 0.0


func _ready() -> void:
	target_position = target_position.normalized()


func _physics_process(delta: float) -> void:
	global_position += target_position * speed * delta
	life += delta
	collision(get_collider())
	if life > 3:
		queue_free()


func collision(with: Node2D) -> void:
	if not with: return
	if with is Player:
		with.die()
