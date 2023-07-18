class_name Room extends Node2D

@export var music : AudioStream
var spawn_points : Array
@onready var player := get_node_or_null("Player") as Player


func _ready() -> void:
	GLB.play_music(music)
	var sp := get_node_or_null("SpawnPoints")
	for i in get_children():
		if "z_index" in i:
			i.z_index -= 1
	if sp:
		spawn_points = sp.get_children()
	if spawn_points and player and GLB.spawn_point > -1:
		player.global_position = spawn_points[GLB.spawn_point].global_position
	if player:
		player.room_name = self.name.to_snake_case()
		player.died.connect(_on_player_died)
		player.z_index = 1
	var deads := SAV.ges("dead_players_%s" % name.to_snake_case(), []) as Array
	for i in deads:
		var dead := preload("res://scenes/player/dead.tscn").instantiate()
		add_child(dead)
		dead.transform = i
	z_index = -10
	z_as_relative = false
	GUI.notif_r(false)
	GUI.close_dial()


func _on_player_died() -> void:
	print("ow")
	GUI.notif_r(true)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GLB.change_scene(GLB.changed_scene_to)


