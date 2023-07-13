class_name Room extends Node2D

signal next(where: Vector2i)

const BOX := preload("res://scenes/box.tscn")
const MAGE := preload("res://scenes/enemies/mage_enemy.tscn")
const RAT := preload("res://scenes/enemies/rat.tscn")
const STRIP := preload("res://scenes/enemies/strip.tscn")
const RED_ENEMY := preload("res://scenes/enemies/red_enemy.tscn")
const CONCRETE := preload("res://scenes/enemies/concrete.tscn")

var enemies := []

var tilemap : TileMap
var am_ready := false
var genned_next := false
@onready var next_room_gate := $NextRoom as Area2D
@onready var locked_door: StaticBody2D = $NextRoom/LockedDoor

var safe := false
var rooms_explored := 0
var boss_room := false

var room_size : Vector2i


func make_room(size_x: int, size_y: int, entrance_y := -1) -> void:
	global_position.y -= entrance_y * 64
	
	if entrance_y < 0:
		safe = true
		entrance_y -= 32767
	var pos := Vector2i((global_position / 64.0).floor())
	var walls : Array = []
	var door := Vector2i(size_x + pos.x, randi_range(pos.y + 1, size_y + pos.y - 3))
	room_size = Vector2i(size_x, size_y)
	for x in range(pos.x, pos.x + size_x):
		for y in range(pos.y, pos.y + size_y):
			# floor
			tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(12, 0))
			tilemap.set_cell(0, door + Vector2i(0, 1), 0, Vector2i(12, 0))
			# walls
			if y == pos.y:
				walls.append(Vector2i(x, y - 2))
				walls.append(Vector2i(x - 1, y - 2))
				for i in 2:
					for j in 4:
						walls.append(Vector2i(x - i, y - j))
						walls.append(Vector2i(x + i, y - j))
			if x == pos.x:
				if y != entrance_y + pos.y and y != entrance_y + pos.y - 1:
					walls.append(Vector2i(x - 1, y))
			if Vector2i(size_x + pos.x, y - 1) != door and Vector2i(size_x + pos.x, y) != door:
				walls.append(Vector2i(size_x + pos.x, y))
			walls.append(Vector2i(x, size_y + pos.y))
			for i in 2:
				for j in 4:
					walls.append(Vector2i(x - i, size_y + pos.y + j))
					walls.append(Vector2i(x + i, size_y + pos.y + j))
			decorate(x, y, pos, Vector2i(size_x, size_y))
	tilemap.set_cells_terrain_connect(1, walls, 0, 0)
	
	next_room_gate.global_position = (door + Vector2i(0, 1)) * 64
	next_room_gate.body_entered.connect(func(_nup): emit_next(door))
	am_ready = true
	if enemies.is_empty():
		locked_door.queue_free()


var decorated_tiles := []
func decorate(x: int, y: int, pos: Vector2i, size: Vector2i) -> void:
	var x0 := x - pos.x
	var y0 := y - pos.y
	if x0 <= 0 or y0 <= 2 or x0 >= size.x - 1 or y0 >= size.y - 1:
		return
	var worldpos := Vector2(x, y) * 64
	var addpos := worldpos + Vector2(32, 32)
	if randf() < 0.04 and not rooms_explored % 10 == 0:
		var box := BOX.instantiate()
		add_child(box)
		box_items(box)
		box.global_position = worldpos
		decorated_tiles.append(Vector2i(x, y))
	if safe: return
	# boss
	if rooms_explored % 10 == 0:
		GUI.status.modulate = Color.RED
		boss_enemy()
		boss_room = true
	else:
		GUI.status.modulate = Color.WHITE
	
	if randf() <= 0.04 and rooms_explored > 4:
		var mage := MAGE.instantiate() as ProjectileEnemy
		add_enemy(mage, addpos)
		mage.fire_delay = maxf(minf(5 / minf(rooms_explored, 0.1), 1.0) - randf(), 0.1)
	elif randf() <= 0.08:
		var rat := RAT.instantiate() as Enemy
		add_enemy(rat, addpos)
	elif randf() <= 0.01 and rooms_explored > 10:
		var strip := STRIP.instantiate()
		add_enemy(strip, addpos)
	elif randf() <= 0.003:
		var enemy := RED_ENEMY.instantiate()
		add_enemy(enemy, addpos)
	elif randf() <= 0.003 and rooms_explored > 15:
		var enemy := CONCRETE.instantiate()
		add_enemy(enemy, addpos)


func add_enemy(enemy: Enemy, pos: Vector2) -> void:
	add_child(enemy)
	enemy.global_position = pos
	enemies.append(enemy)
	enemy.died.connect(remove_enemy)


func remove_enemy(enemy: Enemy) -> void:
	enemies.erase(enemy)
	if enemies.is_empty():
		locked_door.queue_free()


func boss_enemy() -> void:
	if boss_room: return
	var pos := ((Vector2(room_size) / 2.0) * 64) + global_position
	if rooms_explored == 10:
		var en := STRIP.instantiate()
		en.scale = Vector2(1.2, 1.2)
		en.fire_delay = 1
		en.aim_type = 1
		en.burst = 18
		en.health = 20
		en.modulate = Color(0.92489409446716, 0.11251582950354, 0.54818958044052)
		add_enemy(en, pos)
	elif rooms_explored == 20:
		var mage := MAGE.instantiate()
		mage.scale = Vector2(1.2, 1.2)
		mage.fire_delay = 0.04
		mage.health = 30
		add_enemy(mage, pos)
		mage.modulate = Color(0.71164417266846, 0.5357700586319, 0.69492834806442)
	elif rooms_explored == 30:
		var en := RED_ENEMY.instantiate()
		en.scale = Vector2(3, 3)
		en.health = 400
		add_enemy(en, pos)
	elif rooms_explored == 40:
		for i in 80:
			var en := RAT.instantiate()
			en.scale.y = 1.2
			en.modulate = Color(0.98431372642517, 0.57647061347961, 0.57647061347961)
			en.health = 15
			#en.set_collision_mask_value(3, true)
			add_enemy(en, pos + Vector2(randf_range(-64, 64), randf_range(-64, 64)))

func box_items(box : Box) -> void:
	if randf() < 0.66:
		box.stored_item = preload("res://items/apple.tres").duplicate()
		if randf() < 0.33:
			box.stored_item.set_count(randi_range(1, 4))
	elif randf() < 0.45 and rooms_explored > 9:
		box.stored_item = preload("res://items/shield_potion.tres").duplicate()
	elif randf() < 0.34:
		box.stored_item = preload("res://items/fireball.tres").duplicate()
		box.stored_item.count = randi_range(3, 9)
	elif randf() < 0.22:
		box.stored_item = preload("res://items/sniper.tres").duplicate()
		box.stored_item.count = randi_range(10, 20)


func emit_next(door) -> void:
	if not am_ready: return
	door = door as Vector2i
	if genned_next: return
	next.emit(door + Vector2i(0, 1))
	genned_next = true
	next_room_gate.queue_free()

	

