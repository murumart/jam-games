extends Room

var playerpos : Vector2
func _on_check_box_toggled(button_pressed: bool) -> void:
	if is_instance_valid(player):
		playerpos = player.global_position
	if not button_pressed:
		player.die()
	else:
		player = preload("res://scenes/player/player.tscn").instantiate()
		player.room_name = name.to_snake_case()
		add_child(player)
		player.global_position = playerpos


func _on_done_pressed() -> void:
	GLB.spawn_point = 3
	GLB.change_scene("res://scenes/rooms/corridor.tscn")
