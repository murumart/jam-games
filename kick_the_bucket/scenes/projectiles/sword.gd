extends Projectile


func _ready() -> void:
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
	$WorldCollision.body_entered.connect(
		world_collided
		)


var counter := 0.0
func _physics_process(delta: float) -> void:
	
	position += direction * speed * delta * (
		1 if counter < 0.1 else -1
	)
	
	counter += delta
	if counter >= 0.2: queue_free()


func world_collided(_node: Node2D) -> void:
	counter += 0.1
