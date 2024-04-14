extends Node2D

const UIType := preload("res://scenes/main_ui/main_ui.gd")

var rooms_map := {}
var inventory := {}

@onready var ui := $UI as UIType
@onready var battle_manager := $BattleManager as BattleManager

@onready var demon_1_spot: DemonGenerator = $Demon1Spot


func _ready() -> void:
	gen_dungeon()
	battle_manager.battler_info_returned.connect(func(info: BattlerInfo, is_enemy: bool):
		ui.add_battle_info(info, is_enemy)
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
	const DESIRED_ROOMS := 6
	var head := Vector2i()
	while rooms_map.size() <= DESIRED_ROOMS:
		if rooms_map.get(head, false):
			if randf() < 0.5:
				head.x += (randi() % 2) * 2 - 1
			else:
				head.y += (randi() % 2) * 2 - 1
			continue
		rooms_map[head] = true
		tiles_ar.append(head)
		if randf() < 0.5:
			head.x += (randi() % 2) * 2 - 1
		else:
			head.y += (randi() % 2) * 2 - 1
	ui.set_tiles(tiles_ar)
	ui.move_to_room(Vector2i.ZERO)


