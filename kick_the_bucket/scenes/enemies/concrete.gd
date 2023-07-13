extends Enemy

@onready var world_collision: RayCast2D = $WorldCollision


func _ready() -> void:
	super._ready()
	sprite = $Sprite as Sprite2D


func _physics_process(delta: float) -> void:
	velocity = world_collision.target_position.normalized() * speed
	
	var col := world_collision.is_colliding()
	var col_point := world_collision.get_collision_point()
	var col_normal := world_collision.get_collision_normal()
	#print(col, " ", col_point, " ", col_normal)
	if col:
		world_collision.target_position = col_normal + Vector2(
			randf_range(-1, 1), randf_range(-0.2, 0.2))
		world_collision.target_position = world_collision.target_position.normalized() * 32
		if col_normal == Vector2.ZERO:
			world_collision.target_position = Vector2.from_angle(randf() * TAU)
	
	sprite.rotation += velocity.x * delta * 0.05
	
	move_and_slide()


func hurt(amount: float) -> void:
	super.hurt(amount)
	world_collision.target_position = Vector2.from_angle(randf() * TAU)
