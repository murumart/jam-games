class_name ProjectileEnemy extends Enemy

@export var PROJECTILE : PackedScene
@onready var fire_sound: AudioStreamPlayer2D = get_node_or_null("FireSound")
@export_enum("aim", "circle") var aim_type := 0
@export var burst := 1

@export var fire_delay := 1.0


func _ready() -> void:
	super._ready()
	var timer := Timer.new()
	add_child(timer)
	timer.start(fire_delay)
	timer.timeout.connect(fire_fireball)


func fire_fireball() -> void:
	if not target: return
	if dead: return 
	match aim_type:
		0:
			for i in burst:
				var projectile := PROJECTILE.instantiate()
				add_child(projectile)
				projectile.top_level = true
				projectile.global_position = global_position
				projectile.position.y -= 48
				projectile.direction = projectile.global_position.direction_to(
					target.global_position) + Vector2(
					randf_range(-randf() * burst * 0.1, randf() * burst * 0.1),
					randf_range(-randf() * burst * 0.1, randf() * burst * 0.1))
		1:
			for i in burst:
				var angle := (TAU / burst) * i
				var projectile := PROJECTILE.instantiate()
				add_child(projectile)
				projectile.top_level = true
				projectile.global_position = global_position
				projectile.position.y -= 48
				projectile.direction = Vector2.from_angle(angle +
				Engine.get_frames_drawn() * 0.05)
	if fire_sound: fire_sound.play()

