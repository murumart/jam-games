extends Node

var mapgen := MapGenerator.new()


func _init() -> void:
	randomize()
	seed(randi())
