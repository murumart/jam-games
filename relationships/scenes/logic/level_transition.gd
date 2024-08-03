extends Node

# handles changing scenes

const SCREEN_SIZE := Vector2(384, 216)

signal scene_changed
signal fade_finished

# this specifies the type of change between scenes
var gate_id: StringName
var canvas_layer := CanvasLayer.new()
var screen_fade_order := Node2D.new()


func _ready() -> void:
	add_child(canvas_layer)
	canvas_layer.add_child(screen_fade_order)
	screen_fade_order.z_index = 121


# instead of get_tree().change_scene() or whatever
func change_scene_to(path: String, options := {}) -> void:
	get_current_scene().queue_free()
	var free_us := get_tree().get_nodes_in_group("free_on_scene_change")
	if options.get("free_those_nodes", true):
		for node in free_us:
			node.call_deferred("queue_free")
	await get_tree().process_frame
	var new_scene: Node = load(path).instantiate()
	get_tree().root.call_deferred("add_child", new_scene, false)
	if new_scene.has_method("_option_init"):
		new_scene._option_init(options)
	scene_changed.emit()


# this should be a default gdscript function cmon
# turns out it kinda is already. damn
func get_current_scene() -> Node:
	#return get_tree().current_scene
	return get_tree().root.get_child(-1)


# change level with fancy fade
func level_transition(path: String, op := {}) -> void:
	get_tree().call_group("free_on_level_transition", "queue_free")
	var fadetime: float = op.get("fade_time", 0.4)
	fade_screen(
		op.get("start_color", Color(0, 0, 0, 0)),
		op.get("end_color", Color.BLACK),
		fadetime
	)
	await fade_finished
	print("changing scene")
	change_scene_to(path, op)
	await scene_changed
	if not op.get("abrupt_end", false):
		fade_screen(
			op.get("end_color", Color.BLACK),
			op.get("start_color", Color(0, 0, 0, 0)),
			fadetime
		)
	else:
		fade_screen(Color.TRANSPARENT, Color.TRANSPARENT, 0.1)


func fade_screen(start: Color, end: Color, time := 1.0, options := {}) -> void:
	if options.get("kill_rects", false):
		for child: Node in screen_fade_order.get_children():
			child.queue_free()
	var tw := create_tween()
	var rect := ColorRect.new()
	rect.size = SCREEN_SIZE
	rect.color = start
	screen_fade_order.add_child(rect)
	tw.tween_property(rect, "color", end, time)
	tw.tween_callback(func():
		self.fade_finished.emit()
		if is_instance_valid(rect) and options.get("free_rect", true):
			rect.queue_free()
	)
