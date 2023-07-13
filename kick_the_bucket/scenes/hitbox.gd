class_name Hitbox extends Area2D

@export var target : Node2D


func damage(amount: float) -> void:
	if "hurt" in target:
		target.hurt(amount)

