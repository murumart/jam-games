extends Node2D

@onready var pic: Sprite2D = $Sprite2D

var images := ["res://scenes/intro/summerday.png","res://scenes/intro/house.png","res://scenes/intro/gaming.png","res://scenes/intro/suddenly.png","res://scenes/intro/snniff.png","res://scenes/intro/eww.png","res://scenes/intro/disclaimer.png"]

var currimage := 0
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		currimage += 1
		GUI.notif_space(false)
		if currimage < images.size():
			pic.texture = load(images[currimage])
		
		if currimage == images.size() - 2:
			create_tween().tween_property(GLB.current_player, "pitch_scale", 0.97, 2.0)
			pass
		elif currimage == images.size() - 1:
			GLB.play_music(null)
		elif currimage >= images.size(): 
			GLB.change_scene("res://scenes/rooms/gaming_room.tscn")


func _ready() -> void:
	if not SAV.ges("stinky", true):
		GLB.change_scene("res://scenes/rooms/bathroom.tscn")
	pic.texture = load(images[currimage])
	GLB.play_music(load("res://music/awfulintro.ogg"))
	GUI.notif_space(true)
