class_name BattleManager extends Node

signal battler_info_returned(info: BattlerInfo, is_enemy: bool)

var player: Battler
var enemy: Battler

@export var player_spot: DemonGenerator
@export var enemy_spot: DemonGenerator
@export var ui: Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_home"):
		player.attack(enemy)
	if event.is_action_pressed("ui_page_down"):
		enemy.attack(player)


func start_battle() -> void:
	player_spot.get_children().map(func(a): a.queue_free())
	enemy_spot.get_children().map(func(a): a.queue_free())
	enemy = enemy_spot.generate(null)
	enemy.battler_info_returned.connect(func(a): battler_info_returned.emit(a, true))
	enemy_spot.add_child(enemy)

	await create_tween().tween_interval(3.0).finished
	ui.open_drawing_tablet()

	ui.summoning_circle_screen.demon_summoned.connect(func(stats: DemonStats):
		player = player_spot.generate(stats)
		player.battler_info_returned.connect(func(a): battler_info_returned.emit(a, false))
		player_spot.add_child(player)
	, CONNECT_ONE_SHOT)


