extends Node

var mapgen := MapGenerator.new()


func _init() -> void:
	randomize()
	seed(randi())


func _ready() -> void:
	get_window().set_mode(Window.MODE_MAXIMIZED)
