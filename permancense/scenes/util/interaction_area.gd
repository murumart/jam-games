extends Area2D

signal interacted

var player_in := false
var locked := false

func _ready() -> void:
	body_entered.connect(func(_a):
		player_in = true
		GUI.notif_space(true))
	body_exited.connect(func(_a):
		player_in = false
		GUI.notif_space(false))
	GUI.dial_opened.connect(func(): locked = true)
	GUI.dial_closed.connect(func(): locked = false)


func _unhandled_input(event: InputEvent) -> void:
	if not locked and player_in:
		
		if event.is_action_pressed("ui_accept"):
			interacted.emit()
