extends MarginContainer

signal move_requested(dir: Vector2)
signal summon_screen_requested

@onready var left: Button = %Left
@onready var right: Button = %Right
@onready var up: Button = %Up
@onready var down: Button = %Down
@onready var label: Label = %Label
@onready var demon_summon_button: Button = %DemonSummonButton


func _ready() -> void:
	left.pressed.connect(func(): move_requested.emit(Vector2.LEFT))
	right.pressed.connect(func(): move_requested.emit(Vector2.RIGHT))
	up.pressed.connect(func(): move_requested.emit(Vector2.UP))
	down.pressed.connect(func(): move_requested.emit(Vector2.DOWN))
	demon_summon_button.pressed.connect(func():
		print("summon button")
		demon_summon_button.disabled = true
		summon_screen_requested.emit()
	)
	demon_summon_button.hide()


func available_movement_display(dict: Dictionary) -> void:
	if dict.is_empty():
		left.hide()
		right.hide()
		up.hide()
		down.hide()
		label.text = "moving..."
	else:
		label.text = "where to go?"
	for x in dict:
		get(x).visible = dict[x]
	demon_summon_button.hide()


func battle_start() -> void:
	label.text = "an encounter!"
	demon_summon_button.show()
	demon_summon_button.disabled = false


func battle_end() -> void:
	GeneralAnimations.intro_animation(self)
	label.text = "it is over."
	show()
