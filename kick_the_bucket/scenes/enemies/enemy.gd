class_name Enemy extends CharacterBody2D

signal died(who: Enemy)

@export var speed := 100

@export var health := 20.0
var target : Node2D
@onready var sprite := get_node_or_null("Sprite")
var dead := false


func _ready() -> void:
	add_to_group("enemies")
	$DetectionArea.body_entered.connect(_player_entered_detection_area)
	$DetectionArea.body_exited.connect(_player_exited_detection_area)


func _physics_process(_delta: float) -> void:
	var dir := Vector2()
	if target:
		dir = (target.global_position - global_position).normalized()
		if target is Player:
			if target.ghost and target.ghost_life < 0.2: target = null
	if sprite:
		sprite.scale.x = int(dir.x < 0) * 2 - 1
	
	velocity = dir * speed
	
	move_and_slide()


func _player_entered_detection_area(player: Node2D) -> void:
	target = player


func _player_exited_detection_area(player: Node2D) -> void:
	target = null


func hurt(amount: float) -> void:
	if dead: return
	if sprite:
		var tw := create_tween()
		tw.tween_property(sprite, "scale", Vector2(1.1, 0.9), 0.1).from(Vector2(1, 1))
		tw.tween_property(sprite, "scale", Vector2(1, 1), 0.2)
	GLB.bleed(global_position)
	health -= amount
	GLB.play_sound(preload("res://sounds/hit_enemy.ogg"))
	if health <= 0.0:
		die()


func die() -> void:
	dead = true
	var die_sound = get_node_or_null("DieSound")
	if die_sound: die_sound.play()
	set_physics_process(false)
	set_collision_layer_value(3, false)
	var tw := create_tween()
	tw.tween_property(self if not sprite else sprite, "skew", 1.0, 0.3).set_ease(Tween.EASE_IN)
	tw.tween_callback(func(): died.emit(self))
	tw.tween_callback(queue_free)




