extends Page


func _ready() -> void:
	super._ready()
	$AnimationPlayer.play("end")


func _play_music() -> void:
	GLB.play_music(preload("res://scenes/pages/bigman/bigman.ogg"))
