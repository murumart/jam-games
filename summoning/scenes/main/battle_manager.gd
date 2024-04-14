class_name BattleManager extends Node

signal battler_info_returned(info: BattlerInfo, is_enemy: bool)
signal battle_ended

const UIType := preload("res://scenes/main_ui/main_ui.gd")

var player: Battler
var enemy: Battler

var current: Battler
var other: Battler:
	get:
		return _other()

@export var player_spot: DemonGenerator
@export var enemy_spot: DemonGenerator
@export var player_wizard: Wizard
@export var enemy_wizard: Wizard
@export var ui: UIType


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_home"):
		player.attack(enemy)
	if event.is_action_pressed("ui_page_down"):
		enemy.attack(player)


func start_battle() -> void:
	ui.battlestart()
	player_spot.get_children().map(func(a): a.queue_free())
	enemy_spot.get_children().map(func(a): a.queue_free())
	_position_enemy_wizard(true)
	enemy = enemy_spot.generate(DemonStats.new())
	enemy.battler_info_returned.connect(func(a): battler_info_returned.emit(a, true))
	enemy_spot.add_child(enemy)

	ui.summoning_circle_screen.demon_summoned.connect(func(stats: DemonStats):
		player = player_spot.generate(stats)
		player.battler_info_returned.connect(func(a): battler_info_returned.emit(a, false))
		player_spot.add_child(player)

		var fast := _faster()
		ui.message(str(fast.demon_name, " is faster, attacks first!"))
		current = fast
		await get_tree().create_timer(2.0).timeout
		ui.message("START THE BRAWL!")
		_turn()
	, CONNECT_ONE_SHOT)


func reset():
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(enemy):
		enemy.queue_free()


func _position_enemy_wizard(inout: bool) -> void:
	if inout:
		enemy_wizard.random_colours()
		var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(enemy_wizard, "position:x", 525, 1.0)
		return
	create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(enemy_wizard, "position:x", 650, 1.0)


func _swap() -> void:
	if current == player:
		current = enemy
		return
	current = player


func _other() -> Battler:
	if current == player:
		return enemy
	return player


func _faster() -> Battler:
	if enemy.demon_stats.speed > player.demon_stats.speed:
		return enemy
	return player


func _turn() -> void:
	# other attacked during last turn
	if current.dead:
		_battle_ended()
		return
	current.attack(other)
	current.attack_finished.connect(_turn, CONNECT_ONE_SHOT)
	_swap()


func _battle_ended() -> void:
	if enemy.dead:
		_position_enemy_wizard(false)
		var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(player, "scale", Vector2(2.0, 0.5), 1.0)
		tw.parallel().tween_property(player, "modulate", Color(1, 0, 0.5, 0.0), 0.9)
		await create_tween().tween_interval(2.0).finished
		reset()
		battle_ended.emit()

