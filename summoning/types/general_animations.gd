class_name GeneralAnimations


static func intro_animation(on_what: CanvasItem, timescale: float = 1.0) -> void:
	var tw := on_what.create_tween().set_trans(Tween.TRANS_SPRING)
	tw.tween_property(
			on_what, "scale:x", on_what.scale.x, 0.15 * timescale).from(2.0)
	tw.parallel().tween_property(
			on_what, "scale:y", on_what.scale.y, 0.1 * timescale).from(0.0)
	tw.parallel().tween_property(
			on_what, "modulate", on_what.modulate, 0.2 * timescale).from(Color(0.5, 0.0, 0.5, 0.0))
	tw.parallel().tween_property(
			on_what, "rotation", on_what.rotation, 0.3 * timescale).from(randf_range(-0.5, 0.5))
