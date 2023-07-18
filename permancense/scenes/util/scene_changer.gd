extends Area2D

@export_file("*.tscn") var room_path := ""
@export var spawn_point := 0
@export var manual := false

var player_in := false


func _ready() -> void:
	body_entered.connect(entered.unbind(1))
	body_exited.connect(exited.unbind(1))


func entered():
	player_in = true
	if not manual:
		GLB.spawn_point = spawn_point
		GLB.change_scene(room_path)
		return
	GUI.notif_space(true)


func exited():
	player_in = false
	GUI.notif_space(false)


func _unhandled_input(event: InputEvent) -> void:
	if player_in:
		
		if event.is_action_pressed("ui_accept"):
			GLB.spawn_point = spawn_point
			GLB.change_scene(room_path)

