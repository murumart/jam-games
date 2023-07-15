extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var player: Player = $Player


func _ready() -> void:
	mapgen()


func mapgen() -> void:
	var gen := GLB.mapgen
	var img := gen.get_img()
	
	var hills : Array[Vector2i] = []
	for x in MapGenerator.WSIZEX:
		for y in MapGenerator.WSIZEY:
			tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(randi() % 3, 0))
			if not img.get_pixel(x, y).r < 1:
				hills.append(Vector2i(x, y))
	tile_map.set_cells_terrain_connect(1, hills, 0, 0)
	player.global_position = Vector2(MapGenerator.CENTER) * 16

