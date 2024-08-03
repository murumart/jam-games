class_name BoolChecker extends Node

enum Modes {ALL, ANY}

@export var check_mode: Modes
@export var conditions: Array[Condition] = []


func _enter_tree() -> void:
	for c in conditions:
		c._parent = self


func is_true() -> bool:
	if check_mode == Modes.ANY:
		return conditions.any(func(a: Condition): return a.is_true())
	return conditions.all(func(a: Condition): return a.is_true())

