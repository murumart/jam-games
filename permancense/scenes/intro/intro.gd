extends Node2D

@onready var pic: Sprite2D = $Sprite2D

var images := ["res://scenes/intro/summerday.png","res://scenes/intro/house.png","res://scenes/intro/gaming.png","res://scenes/intro/suddenly.png","res://scenes/intro/snniff.png","res://scenes/intro/eww.png","res://scenes/intro/disclaimer.png"]

var currimage := 0
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		currimage += 1
		if currimage < images.size():
			pic.texture = load(images[currimage])
		if currimage == images.size() - 1:
			GLB.play_music(null)


func _ready() -> void:
	pic.texture = load(images[currimage])
	GLB.play_music(load("res://music/awfulintro.ogg"))
