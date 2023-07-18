extends Node2D

const BULLET := preload("res://scenes/util/bullet.tscn")

@export_enum("straight", "circle") var fire_mode : String= "straight"
@export var cooldown := 1.0
@export var burst := 1
@export var bullet_speed := 200.0
@export var add_rotation := 0.0


func _ready() -> void:
	fire()
	$Timer.start(cooldown)
	$Timer.timeout.connect(fire)


func fire() -> void:
	rotation += deg_to_rad(add_rotation)
	for i in burst:
		var bullet := BULLET.instantiate() as Bullet
		add_child(bullet)
		bullet.speed = bullet_speed
		bullet.top_level = true
		bullet.global_position = self.global_position
		match fire_mode:
			"straight":
				bullet.target_position = Vector2.from_angle(rotation + PI / 2)
				
				await get_tree().create_timer(0.1).timeout
			"circle":
				var angle := (TAU / burst) * i
				bullet.target_position = Vector2.from_angle(angle + rotation)

