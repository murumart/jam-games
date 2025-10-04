extends Control

@onready var play_button: Button = $VBoxContainer/PlayButton


func _ready() -> void:
	play_button.pressed.connect(func() -> void:
		Manager.switch_level_to_path("res://scn_intro_1.tscn")
	)
