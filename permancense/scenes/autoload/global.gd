extends Node

var current_player : AudioStreamPlayer


func _init() -> void:
	randomize()
	seed(randi())


func _ready() -> void:
	pass
	await get_tree().process_frame


func play_music(stream : AudioStream) -> void:
	if current_player and current_player.stream == stream:
		return
	if not stream:
		if current_player:
			var tw := create_tween().set_parallel()
			tw.tween_property(current_player, "volume_db", -40, 1.0)
			tw.tween_callback(current_player.queue_free)
			tw.tween_callback(func(): current_player = null)
		return
		
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = 0
	add_child(player)
	
	if current_player:
		var tw := create_tween().set_parallel()
		tw.tween_property(current_player, "volume_db", -40, 1.0)
		tw.tween_callback(current_player.queue_free)
		tw.tween_callback(func(): current_player = null)
	create_tween().set_parallel(
		).tween_property(player, "volume_db", 0.0, 1.0)
	player.play()
	current_player = player
