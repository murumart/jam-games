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


func calc_attack_damage() -> float:
	return power + 1 + (bravery * 0.1) - (incorporeality * 0.1)


func calc_received_damage(input: float, prpts := {}) -> float:
	return maxf(input - (maxf(defense - prpts.get(&"piercing", 0), 0)), 0)

