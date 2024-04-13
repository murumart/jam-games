extends Node

signal battler_info_returned(info: BattlerInfo, is_enemy: bool)

var player: Battler
var enemy: Battler


func start_battle() -> void:
	for x in get_children():
		x.queue_free()
	player = Battler.new()
	enemy = Battler.new()
	player.battler_info_returned.connect(func(a): battler_info_returned.emit(a, false))
	enemy.battler_info_returned.connect(func(a): battler_info_returned.emit(a, true))
	add_child(player)
	add_child(enemy)


