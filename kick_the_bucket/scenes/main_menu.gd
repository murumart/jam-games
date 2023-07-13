extends Control

@onready var start_game_button: Button = $Panel/CenterContainer/VBoxContainer/StartGameButton
@onready var quit_game_button: Button = $Panel/CenterContainer/VBoxContainer/QuitGameButton
@onready var volume_slider: HSlider = $Panel/CenterContainer/VBoxContainer/HSlider
@onready var results: Control = $Results
@onready var report_text: Label = $Results/Scroll/Label

var report_base := "~Report~
Your real estate empire gained %s empty rooms to sell.
%s
Sadly, you died for real, so your riches will be inherited by your %s.

Thanks for playing."
var report_first := "you were the first in this business."
var report_nd := "you were the %snd in this business "
var report_more := "and had %s more rooms than your predeccesor."
var report_less := "and discovered less rooms than your predecessor."
var family_members := ["aunt", "uncle", "cousin", "niece", "mother", "father",
	"son", "daughter", "stew", "clone", "church", "employer", "boss"]


func _ready() -> void:
	GUI.set_loading(false)
	GUI.reset()
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	start_game_button.pressed.connect(
		func():
			GUI.set_loading(true)
			get_tree().change_scene_to_file("res://scenes/main.tscn")
	)
	quit_game_button.pressed.connect(
		func():
			get_tree().quit()
	)
	if GLB.requesting_report:
		$Results.show()
		GLB.requesting_report = false
		construct_report(GLB.previous_compared_score)
		$Results/AnimationPlayer.play("scroll_open")


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(volume_slider.value))
	GLB.play_sound(preload("res://sounds/step.ogg"))


func construct_report(rooms: int) -> void:
	var previous_score := GLB.get_save("scores", "high", 0) as int
	var explorers_amount := GLB.get_save("explorers", "amount", 0) as int
	report_text.text = report_base % [
		rooms,
		(func(): 
		if previous_score <= 1:
			return report_first
		if previous_score < rooms:
			return str((report_nd % explorers_amount) +
				(report_more % (rooms - previous_score)))
		if previous_score >= rooms:
			return str((report_nd % explorers_amount) + report_less)
		return ""
		).call(),
		family_members.pick_random()
	]
	GLB.store_high_score(rooms)

