extends AnimatedSprite2D


func _ready() -> void:
	if not SAV.ges("stinky", true): queue_free()
