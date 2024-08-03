class_name DeathArea extends Area2D


func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	monitorable = false
	var level_path := LTS.get_current_scene().scene_file_path
	body_entered.connect(func(_what):
		LTS.level_transition(level_path)
	)
