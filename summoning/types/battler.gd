class_name Battler extends Node

signal battler_info_returned(BattlerInfo)

var max_health := 100.0
var health := 100.0

var battler_info: BattlerInfo


func _ready() -> void:
	battler_info = preload("res://scenes/main_ui/battler_info.tscn").instantiate()
	battler_info_returned.emit(battler_info)
	battler_info.init_health(health, max_health)


func attack(target: Battler) -> void:
	print(self, " attacked ", target, "!")
	target.hurt(10)


func hurt(amount: float) -> void:
	amount = absf(amount)
	health -= amount
	battler_info.set_health(health)
	if health <= 0:
		print("dead")

