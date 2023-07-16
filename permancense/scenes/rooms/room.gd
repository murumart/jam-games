class_name Room extends Node2D

@export var music : AudioStream


func _ready() -> void:
	GLB.play_music(music)
