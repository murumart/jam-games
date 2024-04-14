class_name DemonStats extends Resource

const STATS = {
	&"health": {},
	&"defense": {},
	&"speed": {},
	&"power": {},
	&"piercing": {},
	&"evasion": {},
	&"incorporeality": {},
	&"temperature": {},
	&"bravery": {},
	&"birdness": {},
}

@export var health := 10
@export var defense := 0
@export var speed := 0
@export var power := 0

@export var piercing := 0
@export var evasion := 0
@export var incorporeality := 0
@export var temperature := 0
@export var bravery := 0
@export var birdness := 0


func calc_attack() -> Dictionary:
	var attk := {}
	attk[&"damage"] = 2 + power + (bravery * 0.1) - (incorporeality * 0.1)
	return attk


func calc_received_damage(prpts: Dictionary) -> float:
	var attack := prpts[&"damage"] as float
	return maxf(attack - (maxf(defense - prpts.get(&"piercing", 0), 0)), 0)


func _to_string() -> String:
	return JSON.stringify(STATS.keys().map(func(a): return str(a, "=", get(a))))


func difference(minus: DemonStats) -> float:
	var diff := 0.0
	for k in STATS.keys():
		diff += get(k) - (minus.get(k) if minus else 0)
	return diff


