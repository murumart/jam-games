class_name PuzzleButton extends Node2D

signal pressed
signal released

const MODE_COLORS := {
	Modes.TOGGLE: Color.LAWN_GREEN,
	Modes.PRESSURE: Color.ROYAL_BLUE
}

enum Modes {TOGGLE, PRESSURE}

@export var mode := Modes.TOGGLE
@export var is_pressed := false

@onready var button_press_test: Area2D = $ButtonPressTest
@onready var moving_collider: AnimatableBody2D = $MovingCollider
@onready var button_texture: Sprite2D = $ClipArea/ButtonTexture
@onready var glow := %Glow
@onready var press_sound: AudioStreamPlayer = $Press
@onready var release_sound: AudioStreamPlayer = $Release


func _ready() -> void:
	button_press_test.body_entered.connect(_thing_entered)
	button_press_test.body_exited.connect(_thing_exited)
	button_texture.modulate = MODE_COLORS[mode]
	glow.modulate = MODE_COLORS[mode]
	_press_animation()


func _thing_entered(_thing: Node2D) -> void:
	if is_pressed:
		return
	is_pressed = true
	_press_animation()
	pressed.emit()
	press_sound.play()


func _thing_exited(_thing: Node2D) -> void:
	if not is_pressed:
		return
	if mode == Modes.PRESSURE:
		is_pressed = false
		_press_animation()
		released.emit()
		release_sound.play()


func _press_animation() -> void:
	glow.modulate.a = 0.05 if not is_pressed else 0.9
	if is_pressed:
		var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		t.tween_property(moving_collider, "position:y", 5, 0.3)
		return
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(moving_collider, "position:y", 0, 0.3)

