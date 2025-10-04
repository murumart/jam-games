extends Node

var gate_id: StringName

var _transitioning := false
var _canvas_layer: CanvasLayer


func _ready() -> void:
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.transform = _canvas_layer.transform.scaled(Vector2(2, 2))
	add_child(_canvas_layer)


func switch_level_to_path(path: String) -> void:
	var current_scene := get_tree().root.get_child(-1)
	current_scene.queue_free()

	await get_tree().process_frame # waiting for free queue
	assert(ResourceLoader.exists(path))
	var new_scene: Node = (load(path) as PackedScene).instantiate()
	#var new_scene_name := new_scene.name
	get_tree().root.add_child(new_scene)


func level_transition(path: String, gate_id_: StringName) -> void:
	const fade_time := 0.4
	assert(not _transitioning)
	gate_id = gate_id_
	_transitioning = true
	# on this side
	if is_instance_valid(Player.extant):
		Player.extant.capture(Player.Capturer.LEVEL_TRANSITION)

	var fade := ColorRect.new()
	fade.size = Vector2(160, 120)
	_canvas_layer.add_child(fade)
	var tw := create_tween()
	tw.tween_property(fade, ^"color", Color.BLACK, fade_time).from( Color(Color.BLACK, 0))
	await tw.finished
	await switch_level_to_path(path)

	# on other side now
	if is_instance_valid(Player.extant):
		Player.extant.capture(Player.Capturer.LEVEL_TRANSITION)

	tw = create_tween()
	tw.tween_property(fade, ^"color", Color(Color.BLACK, 0), fade_time).from(Color.BLACK)
	await tw.finished
	if is_instance_valid(Player.extant):
		Player.extant.release(Player.Capturer.LEVEL_TRANSITION)
	_transitioning = false
