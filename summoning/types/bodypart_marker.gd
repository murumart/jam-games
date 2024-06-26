@tool
class_name BodypartMarker extends Node2D

signal finished(final_stats: DemonStats)

const MAX_RECURSION = 96

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
	parts[&"_demon_stats"] = DemonStats.new()
	parts[&"_desired_stats"] = demon_stats
	parts[&"_demon_addition_meta"] = {}
	parts[&"_demon_addition_meta"][&"_max_recursion"] = randi_range(15, MAX_RECURSION)
	_add_next_part(parts, 0)
	parts.erase(&"_part_addition_meta")
	finished.emit(parts[&"_demon_stats"])
	parts.erase(&"_demon_stats")
	parts.erase(&"_desired_stats")


func _add_next_part(parts: Dictionary, rec_depth: int) -> void:
	if rec_depth >= MAX_RECURSION:
		remove_from_group("_bodypart_markers")
		queue_free()
		return
	if not is_in_group("_bodypart_markers"):
		return
	remove_from_group("_bodypart_markers")
	var demon_stats := parts[&"_demon_stats"] as DemonStats
	var desired_stats := parts[&"_desired_stats"] as DemonStats
	var difference := demon_stats.difference(desired_stats)
	var part_dict := _pick_part(parts, difference)
	difference = demon_stats.difference(desired_stats)
	if absf(difference) < 5:
		rec_depth += 20
	if difference > 5:
		rec_depth += 20
	for x in DemonStats.STATS.keys():
		demon_stats.set(x, demon_stats.get(x) + part_dict.get(x, 0))
	var part := part_dict[&"scene"].instantiate() as Node2D
	get_parent().add_child(part)
	part.transform = transform
	var scalet := remap(rec_depth, 0, MAX_RECURSION, 1.0, 0.4)
	part.scale = Vector2(scalet, scalet)
	part.z_index = z_index
	part.show_behind_parent = show_behind_parent

	_intro_animation.call_deferred(part)
	var markers := get_tree().get_nodes_in_group("_bodypart_markers")
	if rec_depth < parts[&"_demon_addition_meta"][&"_max_recursion"]:
		for x: BodypartMarker in markers:
			x.same_as_others = false if not same_as_others else x.same_as_others
			x._add_next_part(parts, rec_depth + 1)
	else:
		for x: BodypartMarker in markers:
			x.type = &"nub"
			x.same_as_others = false
			x._add_next_part(parts, rec_depth + 1)
	queue_free()


func _pick_part(parts: Dictionary, difference: float) -> Dictionary:
	var addition_meta := {}
	var demon_stats := parts[&"_demon_stats"] as DemonStats

	print(difference)
	if same_as_others:
		if not parts.has(&"_part_addition_meta"):
			parts[&"_part_addition_meta"] = {}
		addition_meta = parts[&"_part_addition_meta"]
		if not addition_meta.has(type):
			addition_meta[type] = _rand_from_dict(parts.get(type, {}))
		return addition_meta[type]
	return _rand_from_dict(parts.get(type, {}))


func _intro_animation(thing: Node2D) -> void:
	var tw := thing.create_tween().set_trans(Tween.TRANS_ELASTIC)
	tw.tween_property(thing, "scale:x", thing.scale.x, 1.5).from(2.0)
	tw.parallel().tween_property(thing, "position", thing.position, 2.0).from(Vector2.ZERO)
	tw.parallel().tween_property(thing, "scale:y", thing.scale.y, 1.4).from(0.0)
	tw.parallel().tween_property(thing, "modulate", thing.modulate, 2.0).from(Color(0.5, 0.0, 0.5, 0.0))


func _rand_from_dict(dict: Dictionary) -> Variant:
	return dict[dict.keys().pick_random()] # if this errors you probably misnamed a folder


