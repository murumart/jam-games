class_name Main extends Node2D

const ROOM := preload("res://scenes/room.tscn")
const GHOST := preload("res://scenes/enemies/evil_ghost.tscn")
const GOD_EYE := preload("res://scenes/enemies/god_eye.tscn")

@onready var tilemap := $TileMap
@onready var music: AudioStreamPlayer = $MUSIC
@onready var camera: Camera2D = $Player/Camera
@onready var world_environment: WorldEnvironment = $WorldEnvironment

@onready var player := $Player as Player
@onready var player_start := player.global_position
var bucket_pos := Vector2()
var ghost_timer := Timer.new()

var rooms_explored := 1.0:
	set(to):
		rooms_explored = to
		GUI.set_room(to)

@export var normal_gradient : GradientTexture1D
@export var ghost_gradient : GradientTexture1D



func _ready() -> void:
	world_environment.environment.adjustment_color_correction = normal_gradient
	add_child(ghost_timer)
	ghost_timer.timeout.connect(_on_ghost_timer_timeout)
	ghost_timer.start()
	begin_room()
	test()
	GUI.reset()
	GUI.bars.show()
	GUI.status.show()
	GUI.set_loading(false)


func begin_room() -> void:
	var room := $StartRoom as Room
	room.tilemap = tilemap
	room.make_room(10, 10)
	room.rooms_explored = rooms_explored
	room.next.connect(new_room)


func test() -> void:
	pass


func new_room(where: Vector2i) -> void:
	GUI.set_loading(true)
	var room := ROOM.instantiate()
	await get_tree().process_frame
	add_child(room)
	room.tilemap = tilemap
	room.next.connect(new_room)
	var room_length := randi_range(6, 20)
	var room_height := randi_range(6, 10)
	rooms_explored += 1
	room.rooms_explored = rooms_explored
	if randf() < 0.25:
		room_height += randi_range(2, 5)
	if randf() < 0.25:
		room_length += randi_range(3, 8)
	var entrance_y := randf_range(2, room_height - 1)
	room.global_position = (where + Vector2i(1, 0)) * 64
	await get_tree().process_frame
	room.make_room(room_length, room_height, entrance_y)
	await get_tree().process_frame
	GUI.set_loading(false)


func _on_player_died(as_ghost: bool) -> void:
	music.stop()
	world_environment.environment.adjustment_color_correction = ghost_gradient
	if not as_ghost:
		GUI.show_death_message()
		await GUI.death_message_finished
		music.stream = preload("res://music/ghostthrough.ogg")
		player.ghost_timer.start(
		(player_start.distance_to(player.global_position) / player.speed) + 4.0)
		music.play()
		GUI.hide_death_message()
		GUI.enable_bucket_pivot(true)
		bucket_pos = player.global_position
		player.show()
		player.locked = false
		player.bucket_searching = true
		player.global_position = player_start
		var ge := GOD_EYE.instantiate()
		ge.global_position = player.global_position + (Vector2.from_angle(
		randf_range(-TAU, TAU)) * 400)
		add_child(ge)
		ge.fire_delay = roundi(rooms_explored / 10.0) + 9
	else:
		GUI.show_true_death_message()
		GUI.set_ghost_timer_label(-20)
		player.locked = true
		music.stream = preload("res://music/final_death.ogg")
		music.play()
		var tw := create_tween().set_parallel()
		tw.tween_property(player, "modulate:a", 0.0, 8.0)
		tw.tween_property(camera, "zoom", Vector2(4, 4), 3.0)
		GUI.set_ghost_timer_label(-1)
		await music.finished
		GLB.previous_compared_score = rooms_explored
		GLB.set_save("explorers", "amount",
			GLB.get_save("explorers", "amount", 0) + 1)
		GLB.requesting_report = true
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_player_resurrected() -> void:
	world_environment.environment.adjustment_color_correction = normal_gradient
	music.stop()
	GUI.set_ghost_timer_label(-1)
	player.ghost_timer.stop()
	await get_tree().create_timer(2.0).timeout
	music.stream = preload("res://music/through.ogg")
	music.play()
	GUI.reset()
	GUI.bars.show()
	GUI.status.show()
	GUI.set_loading(false)
	GUI.items.show()


func _on_ghost_timer_timeout() -> void:
	if not player.ghost: return
	if not player.ghost_life > 5: return
	if randf() < 0.6: return
	var ghost := GHOST.instantiate() if randf() < 0.88 else GOD_EYE.instantiate()
	ghost.global_position = player.global_position + (Vector2.from_angle(
	randf_range(-TAU, TAU)) * 400)
	add_child(ghost)
	if ghost is ProjectileEnemy:
		ghost.burst = roundi(sqrt(rooms_explored) * 3)


