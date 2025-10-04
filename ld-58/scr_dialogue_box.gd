class_name DialogueBox extends Node

signal _continue_pressed
signal _skip_pressed

@export var label: RichTextLabel
@export var talk_sound: AudioStreamPlayer
@export var player: Player
@export var hiding_parent: CanvasItem


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		_continue_pressed.emit()
	if event.is_action_pressed(&"ui_cancel"):
		_skip_pressed.emit()


func speak(dial: Array[DialogueLine]) -> void:
	var skip := [false]
	if is_instance_valid(player):
		player.capture(Player.Capturer.DIALOGUE)
	if not label.is_visible_in_tree() and is_instance_valid(hiding_parent):
		hiding_parent.show()
	for line in dial:
		skip[0] = false
		_skip_pressed.connect(func() -> void: skip[0] = true, CONNECT_ONE_SHOT)
		label.text = line.text
		label.visible_ratio = 0.0
		var mytext := label.get_parsed_text()

		while label.visible_ratio < 1.0:
			var c := mytext[label.visible_characters - 1]
			var ispunct := c in ".,;!?=/"
			var issilent := (not is_instance_valid(talk_sound)
				or ispunct
				or c in " ()[]+-*")
			await get_tree().create_timer(0.025 if not ispunct else 0.075).timeout
			if not issilent:
				talk_sound.play()
			label.visible_characters += 1
			if skip[0]:
				label.visible_ratio = 1.0

		await _continue_pressed

	label.visible_ratio = 0.0
	if is_instance_valid(player):
		player.release.call_deferred(Player.Capturer.DIALOGUE)
	if is_instance_valid(hiding_parent):
		hiding_parent.hide()
