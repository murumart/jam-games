class_name Battler extends Node2D

signal battler_info_returned(BattlerInfo)
signal attack_finished
signal message_emitted(text: String, prop: Dictionary)

var max_health := 100.0
var health := 100.0
var demon_name := ""

var dead: bool:
	get:
		return health <= 0

var demon_stats: DemonStats
var battler_info: BattlerInfo


func _ready() -> void:
	battler_info = preload("res://scenes/main_ui/battler_info.tscn").instantiate()
	battler_info_returned.emit(battler_info)


func _exit_tree() -> void:
	if is_instance_valid(battler_info):
		battler_info.queue_free()


func set_stats(stats: DemonStats) -> void:
	print("the stats that ", self, " has: ", stats)
	demon_stats = stats
	health = demon_stats.health
	max_health = demon_stats.health
	battler_info.init_health(health, max_health)
	battler_info.set_demon_name(demon_name)
	battler_info.display_demon_stats(demon_stats)


func attack(target: Battler) -> void:
	var tw := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	var loc_tpos := to_local(target.global_position)
	tw.tween_method(_jump_arc.bind(loc_tpos), 0.0, loc_tpos.x, 0.5)
	var attack := demon_stats.calc_attack() as Dictionary
	print(self, " attacked ", target, "! (", attack, ")")
	tw.tween_callback(func(): target.hurt(attack))
	tw.tween_method(_jump_arc.bind(loc_tpos), loc_tpos.x, 0.0, 0.5)
	tw.tween_property(self, "position", Vector2(), 0.2)
	tw.finished.connect(func(): attack_finished.emit())


func hurt(properties: Dictionary) -> void:
	var amount: float = demon_stats.calc_received_damage(properties)
	if amount > 0:
		health -= amount
		battler_info.set_health(health)
		var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(self, "scale", Vector2(0.9, 1.1), 0.2)
		tw.parallel().tween_property(self, "modulate", Color.CRIMSON, 0.2)
		tw.tween_property(self, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_SPRING)
		tw.parallel().tween_property(self, "modulate", Color.WHITE, 0.4)
	else:
		var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(self, "scale:x", -1.0, 0.2)
		tw.tween_property(self, "scale:x", 1.0, 0.2)
		message_emitted.emit("attack evaded!")
	if health <= 0:
		print("dead")
		create_tween().tween_property(self, "position:y", 1000, 2.0).set_ease(Tween.EASE_IN)


func _jump_arc(a: float, loc_tpos: Vector2) -> void:
	position = Vector2(
			a,
			pow((a - 0.5 * loc_tpos.x) * 0.333, 2) * 0.05 - 108
	)


func _to_string() -> String:
	return str(demon_name)


