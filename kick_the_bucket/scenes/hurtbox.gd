class_name Hurtbox extends Area2D

@export var damage := 1.0
signal hit


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area: Area2D) -> void:
	if area is Hitbox:
		area.damage(damage)
		hit.emit()
