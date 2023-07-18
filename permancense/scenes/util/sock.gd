extends Area2D

@export var id := -1


func _ready() -> void:
	if SAV.ges("sock_%s_found" % id, false):
		queue_free()
	if not SAV.ges("sock_idea_gotten", false):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SAV.ses("sock_%s_found" % id, true)
		SAV.ses("socks_found", SAV.ges("socks_found", 0) + 1)
		$AudioStreamPlayer.play()
		var tw := create_tween()
		tw.tween_property($Sprite2D, "modulate:a", 0.0, 2.0)
		tw.tween_callback(queue_free)
		$CollisionShape2D.set_deferred("disabled", true)
