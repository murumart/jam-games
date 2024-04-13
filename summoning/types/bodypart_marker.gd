@tool
class_name BodypartMarker extends Node2D

const MAX_RECURSION = 25

@export var type := &""
@export var same_as_others := true


func _init() -> void:
	add_to_group("_bodypart_markers")


func _draw() -> void:
	draw_circle(Vector2.ZERO, 3, Color.DARK_GREEN)
	draw_circle(Vector2.ZERO, 1, Color.GREEN_YELLOW)
	draw_line(Vector2.ZERO, Vector2.DOWN * 5, Color.YELLOW, 1.0)
	draw_line(Vector2.DOWN * 3 - Vector2.RIGHT * 2, Vector2.DOWN * 6, Color.YELLOW, -1.0)
	draw_line(Vector2.DOWN * 3 + Vector2.RIGHT * 2, Vector2.DOWN * 6, Color.YELLOW, -1.0)


func start_generating(parts: Dictionary, demon_stats: DemonStats) -> void:
	parts[&"_demon_stats"] = demon_stats
	_add_next_part(parts, 0)
	parts.erase(&"_part_addition_meta")
	parts.erase(&"_demon_stats")


func _add_next_part(parts: Dictionary, rec_depth: int) -> void:
	if not is_in_group("_bodypart_markers"):
		return
	remove_from_group("_bodypart_markers")
	var part_dict := _pick_part(parts)
	var part := part_dict[&"scene"].instantiate() as Node2D
	get_parent().add_child(part)
	part.transform = transform
	part.z_index = z_index

	_intro_animation.call_deferred(part)
	var markers := get_tree().get_nodes_in_group("_bodypart_markers")
	if rec_depth < MAX_RECURSION:
		for x: BodypartMarker in markers:
			x.same_as_others = same_as_others
			x._add_next_part(parts, rec_depth + 1)
	queue_free()


func _pick_part(parts: Dictionary) -> Dictionary:
	var addition_meta := {}
	var demon_stats := parts[&"_demon_stats"] as DemonStats
	if same_as_others:
		if not parts.has(&"_part_addition_meta"):
			parts[&"_part_addition_meta"] = {}
		addition_meta = parts[&"_part_addition_meta"]
		if not addition_meta.has(type):
			addition_meta[type] = _rand_from_dict(parts.get(type, {}))
		return addition_meta[type]
	return _rand_from_dict(parts.get(type, {}))


func _intro_animation(thing: Node2D) -> void:
	var tw := thing.create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(thing, "scale:x", thing.scale.x, 3.0).from(2.0)
	tw.parallel().tween_property(thing, "position", thing.position, 2.0).from(Vector2.ZERO)
	tw.parallel().tween_property(thing, "scale:y", thing.scale.y, 0.4).from(0.0)
	tw.parallel().tween_property(thing, "modulate", thing.modulate, 1.0).from(Color(0.5, 0.0, 0.5, 0.0))


func _rand_from_dict(dict: Dictionary) -> Variant:
	return dict[dict.keys().pick_random()]


