class_name MapGenerator

static var WSIZEX = 512
static var WSIZEY = 512
static var CENTER := Vector2i()
const CCLEAR := 10

var rng := RandomNumberGenerator.new()

var hill_noise := preload("res://assets/noises/hill_noise.tres").noise


func _init() -> void:
	hill_noise.seed = randi()
	CENTER = Vector2i(WSIZEX / 2, WSIZEY / 2)


func get_img() -> Image:
	var img := hill_noise.get_image(WSIZEX, WSIZEY)
	img.adjust_bcs(0.65, 256.0, 1.0)
	for i in range(WSIZEX / 2 - CCLEAR, WSIZEX / 2 + CCLEAR):
		for j in range(WSIZEX / 2 - CCLEAR, WSIZEX / 2 + CCLEAR):
			if (CENTER - Vector2i(i, j)).length() < CCLEAR:
				img.set_pixel(i, j, Color.BLACK)
	for i in WSIZEX:
		img.set_pixel(i, 0, Color.BLACK)
		img.set_pixel(i, WSIZEY - 1, Color.BLACK)
	for i in WSIZEY:
		img.set_pixel(0, i, Color.BLACK)
		img.set_pixel(WSIZEX - 1, i, Color.BLACK)
	return img
