extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var player: Player = $Player
@onready var camera: Camera2D = $Player/Camera


func _ready() -> void:
	mapgen()


func mapgen() -> void:
	print("starting mapgen")
	var gen := GLB.mapgen
	var img := gen.get_img()
	
	var hills : Array[Vector2i] = []
	for x in MapGenerator.WSIZEX:
		for y in MapGenerator.WSIZEY:
			tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(randi() % 3, 0))
			if not img.get_pixel(x, y).r < 1:
				hills.append(Vector2i(x, y))
	print("placing hills")
	tile_map.set_cells_terrain_connect(1, hills, 0, 0)
	print("setting edges")
	edge_collisions()
	print("spawning player")
	spawn_player()


func spawn_player() -> void:
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = MapGenerator.WSIZEX * 16
	camera.limit_bottom = MapGenerator.WSIZEY * 16
	for i in 199:
		var tpos := Vector2i(randi() % MapGenerator.WSIZEX,
			randi() % MapGenerator.WSIZEY)
		if not tile_map.get_cell_tile_data(1, tpos):
			player.global_position = Vector2(tpos) * 16
			return
	print("spawning player in center")
	player.global_position = Vector2(MapGenerator.CENTER) * 16


func edge_collisions() -> void:
	for coll in $EdgeCollision.get_children():
		match coll.name:
			"North": pass
			"West": pass
			"South": coll.global_position.y = MapGenerator.WSIZEY * 16
			"East": coll.global_position.x = MapGenerator.WSIZEX * 16
		coll.body_entered.connect(edge_reached.bind(coll).unbind(1))


func edge_reached(which: Area2D) -> void:
	var dist := 4.0

	match which.name:
		"North":
			player.global_position.y = (MapGenerator.WSIZEY * 16) - dist
		"West":
			player.global_position.x = (MapGenerator.WSIZEX * 16) - dist
		"South": player.global_position.y = dist
		"East": player.global_position.x = dist

