extends Control

const SumCircScreenType := preload("res://scenes/main_ui/summoning_circle_screen.gd")

@onready var dungeon_tiles: TileMap = %DungeonTiles
@onready var left_wizard_panel: PanelContainer = %LeftWizardPanel
@onready var right_wizard_panel: PanelContainer = %RightWizardPanel
@onready var summoning_circle_screen := $CenterContainer/SummoningCircleScreen as SumCircScreenType


func set_tiles(tiles: Array[Vector2i]) -> void:
	dungeon_tiles.clear()
	dungeon_tiles.set_cells_terrain_connect(0, tiles, 0, 0)
	dungeon_tiles.set_cell(1, tiles.back(), 1, Vector2i(4, 0))


func move_to_room(spot: Vector2i) -> void:
	dungeon_tiles.position = Vector2(spot) * 16 + Vector2(27, 27)


func add_battle_info(info: BattlerInfo, is_enemy: bool) -> void:
	if is_enemy:
		right_wizard_panel.get_children().map(func(a): a.hide(); a.queue_free())
		_funky_child(right_wizard_panel, info)
		return
	left_wizard_panel.get_children().map(func(a): a.hide(); a.queue_free())
	_funky_child(left_wizard_panel, info)


func _funky_child(parent: Node, child: Node) -> void:
	parent.add_child(child)
	if not "position" in child:
		return
	GeneralAnimations.intro_animation(child)


func open_drawing_tablet() -> void:
	summoning_circle_screen.start()

