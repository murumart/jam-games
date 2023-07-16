class_name DialogueArea extends Area2D

@export_multiline var dialogue : String = ""

var player_in := false
var locked := false

func _ready() -> void:
	body_entered.connect(func(_a):
		print("player in")
		player_in = true)
	body_exited.connect(func(_a):
		player_in = false)
	GUI.dial_opened.connect(func(): locked = true)
	GUI.dial_closed.connect(func(): locked = false)


func _unhandled_input(event: InputEvent) -> void:
	if not locked and player_in:
		
		if event.is_action_pressed("ui_accept"):
			print("h")
			GUI.dialogue(dialogue)
