class_name Map extends Node2D

@onready var display: Sprite2D = $Display

var gen : MapGenerator


func _ready() -> void:
	mapgen()


var dat2 := []
func mapgen() -> void:
	gen = GLB.mapgen
	var img := gen.get_img()
	display.texture = ImageTexture.create_from_image(img)


