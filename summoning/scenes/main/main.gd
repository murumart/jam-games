extends Node2D

const UIType := preload("res://scenes/main_ui/main_ui.gd")
const DESIRED_ROOMS := 6

var current_room := Vector2i()
var rooms_map := {}

@onready var ui := $UI as UIType
@onready var battle_manager := $BattleManager as BattleManager

@onready var demon_1_spot: DemonGenerator = $Demon1Spot


func _ready() -> void:
	gen_dungeon()
	Inventory.add_blood(100)
	battle_manager.battler_info_returned.connect(func(info: BattlerInfo, is_enemy: bool):
		ui.add_battle_info(info, is_enemy)
	)
	ui.move_requested.connect(func(dir: Vector2):
		if rooms_map.get(current_room + Vector2i(dir), false):
			rooms_map.get(current_room, {})[&"visited"] = true
			current_room = current_room + Vector2i(dir)
			ui.move_to_room(current_room)
	)
	ui.move_finished.connect(_entered_room)
	ui.cleanup_room_requested.connect(func():
		battle_manager.reset()
	)


func _unhandled_key_input(event: InputEvent) -> void:
	event = event as InputEventKey
	if event == null:
		return
	if event.pressed:
		match event.keycode:
			KEY_1:
				battle_manager.start_battle()
			KEY_3:
				demon_1_spot.get_children().map(func(a): a.queue_free())
				demon_1_spot.generate(null)


func gen_dungeon() -> void:
	var tiles_ar: Array[Vector2i] = []
	var head := Vector2i()
	var nr := 0
	while rooms_map.size() <= DESIRED_ROOMS:
		if rooms_map.get(head, false):
			if randf() < 0.5:
				head.x += (randi() % 2) * 2 - 1
			else:
				head.y += (randi() % 2) * 2 - 1
			continue
		rooms_map[head] = _gen_room_data(nr)
		nr += 1
		tiles_ar.append(head)
		if randf() < 0.5:
			head.x += (randi() % 2) * 2 - 1
		else:
			head.y += (randi() % 2) * 2 - 1
	ui.set_tiles(tiles_ar)
	ui.move_to_room(Vector2i.ZERO)


func _gen_room_data(nr: int) -> Dictionary:
	var d := {}
	# nothing in first room
	if nr == 0:
		d[&"first"] = true
		return d
	d[&"has_enemy"] = randf() < 0.5
	d[&"has_chest"] = randf() < 0.5 and not d[&"has_enemy"]
	return d


func ui_mov_display() -> void:
	ui.available_movement_display(
		{
			"left": false if not rooms_map.get(current_room + Vector2i.LEFT, false) else true,
			"right": false if not rooms_map.get(current_room + Vector2i.RIGHT, false) else true,
			"up": false if not rooms_map.get(current_room + Vector2i.UP, false) else true,
			"down": false if not rooms_map.get(current_room + Vector2i.DOWN, false) else true,
		}
	)


func _entered_room() -> void:
	var room := rooms_map[current_room] as Dictionary
	print(room)
	var enemy := room.get(&"has_enemy", false) as bool
	var visited := room.get(&"visited", false) as bool
	if enemy and not visited:
		battle_manager.start_battle()
		battle_manager.battle_ended.connect(func():
			ui.battle_end()
			ui_mov_display()
		, CONNECT_ONE_SHOT)
		battle_manager.player_lost.connect(func():
			LevelTransition.level_transition(
					get_tree(), 
					"res://scenes/screens/game_over_screen.tscn")
		)
		return
	ui_mov_display()

