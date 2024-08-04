@tool
extends Node2D


@export_range(1, 200) var top_tube_length := 1:
	set(to):
		top_tube_length = to
		$BgUp.region_rect.size.x = 26 + top_tube_length
		$BgUp.position.y = -39 - top_tube_length

@export_range(1, 220) var bottom_tube_length := 1:
	set(to):
		bottom_tube_length = to
		$BgDown.region_rect.size.x = 26 + bottom_tube_length

@export var open := false

@export var player: Player
@export_file("*.tscn") var next_scene := ""


func _ready() -> void:
	assert(is_instance_valid(player), "no player set")


func open_up() -> void:
	if open:
		return
	open = true
	$FinishArea.body_entered.connect(finish.unbind(1))
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property($Cover, "scale:y", 0.0, 1.0)
	tw.parallel().tween_property($Cover, "position:y", -9.0, 1.0)


func close_down() -> void:
	if not open:
		return
	open = false
	$FinishArea.body_entered.disconnect(finish)
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property($Cover, "scale:y", 1.0, 1.0).from(0.0)
	tw.parallel().tween_property($Cover, "position:y", 0.0, 1.0).from(-9.0)


func finish() -> void:
	player.state = Player.States.FREEZE
	if player is ControllablePlayer:
		player.input_enabled = false
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(player, "global_position", global_position, 1.0)
	tw.parallel().tween_property(player, "rotation", TAU * 3, 1.1)
	tw.tween_property(player, "scale", Vector2.ZERO, 0.2)
	tw.finished.connect(func():
		if is_instance_valid(player):
			player.queue_free()
		LTS.level_transition(next_scene)
	)
	

