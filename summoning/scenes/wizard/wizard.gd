class_name Wizard extends Node2D

@onready var body: Node2D = $Pibot/Body
@onready var head: Node2D = $Pibot/Head


func random_colours() -> void:
	body.modulate = Color(randf(), randf(), randf())
	head.modulate = body.modulate.lerp(Color(randf(), randf(), randf()), randf() * 0.25)
