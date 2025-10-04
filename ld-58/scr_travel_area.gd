class_name TravelArea extends Area2D

@export_file_path("*.tscn") var destination_scene: String
@export var gate_id: StringName
@export var output_offset := Vector2(0, 12)


func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(2, true) # player
	body_entered.connect(_player_entered)
	await get_tree().process_frame # player must be ready
	_spawn_player()


func _spawn_player() -> void:
	if not Manager.gate_id or Manager.gate_id != gate_id:
		return
	var player: Player = get_tree().get_first_node_in_group(&"player")
	player.global_position = global_position + output_offset



func _player_entered(_player: Player) -> void:
	Manager.level_transition(destination_scene, gate_id)
