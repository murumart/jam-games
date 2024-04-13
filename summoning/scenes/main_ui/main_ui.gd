extends Control

@onready var dungeon_tiles: TileMap = %DungeonTiles
@onready var left_wizard_panel: PanelContainer = %LeftWizardPanel
@onready var right_wizard_panel: PanelContainer = %RightWizardPanel


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
	var tw := create_tween().set_trans(Tween.TRANS_SPRING)
	tw.tween_property(child, "scale:x", child.scale.x, 0.15).from(2.0)
	tw.parallel().tween_property(child, "scale:y", child.scale.y, 0.1).from(0.0)
	tw.parallel().tween_property(child, "modulate", child.modulate, 0.2).from(Color(0.5, 0.0, 0.5, 0.0))
	tw.parallel().tween_property(child, "rotation", child.rotation, 0.3).from(randf_range(-0.5, 0.5))
