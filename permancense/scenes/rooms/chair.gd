extends Area2D


func _ready() -> void:
	if SAV.ges("bathroom_has_chair", false): queue_free()
	if SAV.ges("has_chair", false): queue_free()
	if SAV.ges("socks_found", 0) < 4: queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if SAV.ges("socks_found") > 3:
			SAV.ses("has_chair", true)
			queue_free()
