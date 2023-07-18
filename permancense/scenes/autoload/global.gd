extends Node

var current_player : AudioStreamPlayer
var spawn_point : int
var loading := true
var changed_scene_to : String = ""


func _init() -> void:
	randomize()
	seed(randi())


func _ready() -> void:
	pass
	await get_tree().process_frame
	loading = false


func play_music(stream : AudioStream) -> void:
	var old_player : AudioStreamPlayer
	if current_player and current_player.stream == stream:
		return
	if not stream:
		if current_player:
			old_player = current_player
			current_player = null
			var tw := create_tween()
			tw.tween_property(old_player, "volume_db", -40, 1.0)
			tw.tween_callback(old_player.queue_free)
		return
		
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = 0
	add_child(player)
	
	if current_player and is_instance_valid(current_player):
		old_player = current_player
		current_player = player
		var tw := create_tween()
		tw.tween_property(old_player, "volume_db", -40, 1.0)
		tw.tween_callback(old_player.queue_free)
	var tw := create_tween()
	tw.tween_property(player, "volume_db", 0.0, 1.0).from(-40.0)
	player.play()
	current_player = player


func change_scene(to: String) -> void:
	if not to: return
	loading = true
	get_tree().root.get_child(-1).queue_free()
	var new_scene := load(to).instantiate() as Node
	await get_tree().process_frame
	get_tree().root.add_child(new_scene)
	changed_scene_to = to
	loading = false

