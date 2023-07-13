extends Node2D


func _ready() -> void:
	$FoundMe.body_entered.connect(found_me)


func found_me(player: Player) -> void:
	if player.locked: return
	player.invincibility = 2.0
	player.ghost = false
	player.bucket_searching = false
	GUI.enable_bucket_pivot(false)
	get_tree().call_group("enemies", "die")
	GLB.play_sound(preload("res://sounds/resurrect.ogg"))
	player.bucket = null
	player.resurrected.emit()
	queue_free()
