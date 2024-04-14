extends PanelContainer

signal demon_summoned(stats: DemonStats)

var inventory := {}

@onready var inventory_panel: Panel = %InventoryPanel
@onready var drawing_tablet: DrawingTablet = %DrawingTablet
@onready var summon_button: Button = %SummonButton
@onready var shadow: TextureRect = $"../Shadow"


func _ready() -> void:
	summon_button.pressed.connect(_summon)


func _input(_event: InputEvent) -> void:
	summon_button.disabled = drawing_tablet.blood.is_empty()


func start() -> void:
	show()
	shadow.show()
	GeneralAnimations.intro_animation(self)
	GeneralAnimations.squeeze_in(shadow, 4.0)
	get_tree().process_frame.connect(func(): DraggableItem.move_area = get_global_rect(), CONNECT_ONE_SHOT)
	DraggableItem.move_area = get_global_rect()
	drawing_tablet.enabled = true


func close() -> void:
	drawing_tablet.enabled = false
	drawing_tablet.clear_board()
	create_tween().tween_property(self, "modulate:a", 0.0, 0.2).finished.connect(hide)
	create_tween().tween_property(shadow, "modulate:a", 0.0, 0.2).finished.connect(shadow.hide)


func _create_draggable_items() -> void:
	for i in inventory.keys():
		for j in inventory[i][&"amount"]:
			_create_item(i)


func _create_item(type: DraggableItem.Types) -> void:
	var item := DraggableItem.create(type)
	item.dragging_finished.connect(func(pos: Vector2):
		if drawing_tablet.get_global_rect().has_point(pos + item.size / 2):
			if not item in drawing_tablet.items:
				drawing_tablet.items.append(item)
				item.add_highlight()
		else:
			drawing_tablet.items.erase(item)
			item.remove_highlight()
	)
	inventory_panel.add_child(item)
	item.position += Vector2(randf() * 20, randf() * 20)


func _summon() -> void:
	summon_button.disabled = true

	var target_stats := DemonStats.new()
	var tablet_items := drawing_tablet.items
	var blood := drawing_tablet.blood
	for i: DraggableItem in tablet_items:
		match i.type:
			DraggableItem.Types.CANDLE:
				target_stats.temperature += 2
			DraggableItem.Types.KNIFE:
				target_stats.piercing += 2
			DraggableItem.Types.SILK:
				target_stats.evasion += 2
			DraggableItem.Types.INCENCE:
				target_stats.incorporeality += 2
			DraggableItem.Types.HEART:
				target_stats.bravery += 2
			DraggableItem.Types.FEATHERS:
				target_stats.birdness += 2

	var circ_mess := drawing_tablet.circle_measurements()
	var item_mess := drawing_tablet.pentagram_measurements()
	var perfection_score := 100.0
	var items_point_reduction := preload(
				"res://resources/item_points_points_curve.tres").sample_baked(
				clampf(drawing_tablet.items.size() * 0.05, 0.0, 1.0))
	for x in target_stats.STATS.keys():
		target_stats.set(x, roundi(target_stats.get(x) * items_point_reduction))
	if not tablet_items.is_empty():
		perfection_score -= circ_mess.circle_centre.distance_to(item_mess.item_centre)
		perfection_score -= absf(circ_mess.average_radius - item_mess.average_distance)
	else:
		perfection_score -= 50
	if drawing_tablet.blood.size() < 10:
		perfection_score -= 50
	target_stats.health += blood.size() * 0.1
	target_stats.defense += blood.size() * 0.01
	target_stats.power += blood.size() * 0.01
	print("PEFECTION SCORE: ", perfection_score)

	demon_summoned.emit(target_stats)
	close()
