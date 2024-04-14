class_name Battler extends Node2D

signal battler_info_returned(BattlerInfo)

var max_health := 100.0
var health := 100.0

var demon_stats: DemonStats
var battler_info: BattlerInfo


func _ready() -> void:
	battler_info = preload("res://scenes/main_ui/battler_info.tscn").instantiate()
	battler_info_returned.emit(battler_info)
	battler_info.init_health(health, max_health)


func attack(target: Battler) -> void:
	print(self, " attacked ", target, "!")
	var tw := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	var saved_pos := position
	var loc_tpos := to_local(target.global_position)
	tw.tween_method(_jump_arc.bind(saved_pos).bind(loc_tpos), 0.0, loc_tpos.x, 0.5)
	tw.tween_callback(func(): target.hurt(10))
	tw.tween_method(_jump_arc.bind(saved_pos).bind(loc_tpos), loc_tpos.x, 0.0, 0.5)
	tw.tween_property(self, "position", Vector2(), 0.2)


func hurt(amount: float) -> void:
	amount = absf(amount)
	health -= amount
	battler_info.set_health(health)
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "scale", Vector2(0.9, 1.1), 0.2)
	tw.parallel().tween_property(self, "modulate", Color.CRIMSON, 0.2)
	tw.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_SPRING)
	tw.parallel().tween_property(self, "modulate", Color.WHITE, 0.4)
	if health <= 0:
		print("dead")


func _jump_arc(a: float, loc_tpos: Vector2, saved_pos: Vector2) -> void:
	position = Vector2(
			a,
			pow((a - 0.5 * loc_tpos.x) * 0.333, 2) * 0.05 - 108
	)

