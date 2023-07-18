class_name Player extends CharacterBody2D

signal died

var speed := 35.0
var friction := 400.0
var acceleration := 800.0
@onready var anim: AnimatedSprite2D = $Sprite2D

var locked := false
var input := Vector2()

var room_name := ""

const DEATH := preload("res://scenes/player/dead.tscn")


func _ready() -> void:
	GUI.dial_opened.connect(func(): locked = true)
	GUI.dial_closed.connect(func(): locked = false)
	$ChairSPrite.visible = SAV.ges("has_chair", false)


func _physics_process(delta: float) -> void:
	input = Input.get_vector("left", "right", "up", "down")
	
	velocity = velocity.move_toward(Vector2(), friction * delta)
	if input: velocity = velocity.move_toward(input * speed, acceleration * delta)
	velocity = velocity.move_toward(velocity.round(), delta)
	anim.speed_scale = velocity.length() * 0.05
	
	if Input.is_action_just_pressed("ui_end"):
		die()
	
	if not locked:
		move_and_slide()


func die() -> void:
	died.emit()
	var dead := DEATH.instantiate()
	add_sibling(dead)
	dead.transform = self.transform
	dead.get_node("Sound").play()
	SAV.appes("dead_players_%s" % room_name, transform)
	queue_free()

