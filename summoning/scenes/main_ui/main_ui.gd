extends Control

const SumCircScreenType := preload("res://scenes/main_ui/summoning_circle_screen.gd")

signal move_requested(dir: Vector2)
signal move_finished
signal cleanup_room_requested

var inventory := {}

@onready var fade: ColorRect = %Fade
@onready var dungeon_tiles: TileMap = %DungeonTiles
@onready var left_wizard_panel: PanelContainer = %LeftWizardPanel
@onready var right_wizard_panel: PanelContainer = %RightWizardPanel
@onready var summoning_circle_screen := $CenterContainer/SummoningCircleScreen as SumCircScreenType
@onready var movement_panel := %MovementPanel
@onready var message_container: MessageContainer = %MessageContainer


func _ready() -> void:
	fade.color.a = 1.0
	available_movement_display({})
	summoning_circle_screen.inventory = inventory
	movement_panel.move_requested.connect(func(dir: Vector2): move_requested.emit(dir))
	movement_panel.summon_screen_requested.connect(func():
		open_drawing_tablet()
	)


func set_tiles(tiles: Array[Vector2i]) -> void:
	dungeon_tiles.clear()
	dungeon_tiles.set_cells_terrain_connect(0, tiles, 0, 0)
	dungeon_tiles.set_cell(1, tiles.back(), 1, Vector2i(4, 0))


func move_to_room(spot: Vector2i) -> void:
	var tw := create_tween().set_trans(Tween.TRANS_CUBIC)
	var moveto := Vector2(-spot) * 16 + Vector2(27, 27)
	movement_panel.available_movement_display({})
	tw.tween_property(dungeon_tiles, "position", moveto, 1.0)
	tw.step_finished.connect(func(_a): cleanup_room_requested.emit(), CONNECT_ONE_SHOT)
	tw.parallel().tween_property(fade, "color:a", 1.0, 0.5)
	tw.tween_property(fade, "color:a", 0.0, 0.5)
	tw.finished.connect(func(): move_finished.emit())


func add_battle_info(info: BattlerInfo, is_enemy: bool) -> void:
	if not is_enemy:
		movement_panel.hide()
	if is_enemy:
		right_wizard_panel.get_children().map(func(a): a.hide(); a.queue_free())
		_funky_child(right_wizard_panel, info)
		return
	_funky_child(left_wizard_panel, info)


func _funky_child(parent: Node, child: Node) -> void:
	parent.add_child(child)
	if not "position" in child:
		return
	GeneralAnimations.intro_animation(child)


func open_drawing_tablet() -> void:
	summoning_circle_screen.start()


func available_movement_display(dict: Dictionary) -> void:
	movement_panel.available_movement_display(dict)


func battlestart() -> void:
	movement_panel.battle_start()


func battle_end() -> void:
	movement_panel.battle_end()


func message(text: String, options := {}) -> void:
	if not options.get("alignment"):
		options["alignment"] = HORIZONTAL_ALIGNMENT_CENTER
	message_container.push_message(text, options)



