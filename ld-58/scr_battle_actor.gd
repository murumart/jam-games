class_name BattleActor extends Node2D

signal action_message(txt: String)
signal data_changed
signal attacked()
signal crit_attacked()

enum AttackMode {
	JAB = 0x1,
	PUNCH = 0x2,
	KICK = 0x4,
	GUARD = 0x8,
}
const ATTACK_MODE_ORDER: PackedByteArray = [AttackMode.JAB, AttackMode.PUNCH, AttackMode.KICK, AttackMode.GUARD]
const ATTACK_MODE_NAMES: PackedStringArray = ["Jab", "Punch", "Kick", "Guard"]

const AttackModeVerb: Dictionary[AttackMode, String] = {
	AttackMode.JAB: "jabs",
	AttackMode.PUNCH: "punches",
	AttackMode.KICK: "kicks",
	AttackMode.GUARD: "guards against",
}

@export var actor_name: String

@export var max_health := 10
@export var health := 10

@export var attack_stat := 1
@export var defense_stat := 1

var vulnerabilities: Dictionary[BattleActor, int] = {}
var _crit_flag := false


func attack(target: BattleActor, mode: AttackMode) -> void:
	var dmg := _calc_attack_damage(target, mode)
	var verb := AttackModeVerb[mode]
	if dmg <= 0 and mode != AttackMode.GUARD:
		verb = "'s attack glances off"
	action_message.emit(actor_name
		+ " " + verb + " " + target.actor_name)
	if _crit_flag:
		action_message.emit("The attack strikes a vulnerability!")
	target.hurt(dmg)
	_vulnerabilise(target)
	if _crit_flag:
		crit_attacked.emit()
	elif dmg >= 1 and mode != AttackMode.GUARD:
		attacked.emit()
	_crit_flag = false
	await get_tree().create_timer(1.3).timeout


func _calc_attack_damage(target: BattleActor, mode: AttackMode) -> int:
	if mode == AttackMode.GUARD:
		vulnerabilities[target] = 0
		return 0
	var dmg := attack_stat
	if (mode & target.vulnerabilities.get(self, 0)) != 0:
		dmg *= 3
		_crit_flag = true
	dmg = maxi(1, dmg - target.defense_stat)
	return dmg


func _vulnerabilise(target: BattleActor) -> void:
	var vuln := 0
	if randf() < 0.3:
		vuln |= AttackMode.JAB
	if randf() < 0.1:
		vuln |= AttackMode.PUNCH
	if randf() < 0.08:
		vuln |= AttackMode.KICK
	target.vulnerabilities[self] = target.vulnerabilities.get(self, 0) | vuln


func hurt(amt: int) -> void:
	if amt == 0:
		return
	health -= amt
	data_changed.emit()
	action_message.emit(actor_name + " lost " + str(amt) + " hp!")
	if health <= 0:
		action_message.emit(actor_name + " was defeated!")
		var tw := create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(self, "global_position:y", global_position.y + 300, 5.0)


func ai_act(enemies: Array[BattleActor], _allies: Array[BattleActor]) -> void:
	await attack(enemies.pick_random(), ATTACK_MODE_ORDER[randi() % ATTACK_MODE_ORDER.size()])


static func construct(n: String, hp: int, def: int, atk: int) -> BattleActor:
	var ba := BattleActor.new()
	ba.actor_name = n
	ba.max_health = hp
	ba.health = hp
	ba.defense_stat = def
	ba.attack_stat = atk
	return ba


func _to_string() -> String:
	return "%s, %s/%s atk %s def %s" % [actor_name, health, max_health, attack_stat, defense_stat]
