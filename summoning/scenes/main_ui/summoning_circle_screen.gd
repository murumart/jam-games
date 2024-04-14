extends PanelContainer

signal demon_summoned(stats: DemonStats)

@onready var inventory_panel: Panel = %InventoryPanel
@onready var drawing_tablet: DrawingTablet = %DrawingTablet
@onready var summon_button: Button = %SummonButton


func _ready() -> void:
	summon_button.pressed.connect(_summon)


func _input(event: InputEvent) -> void:
	summon_button.disabled = drawing_tablet.blood.is_empty()


func start() -> void:
	show()
	GeneralAnimations.intro_animation(self)
	get_tree().process_frame.connect(func(): DraggableItem.move_area = get_global_rect(), CONNECT_ONE_SHOT)
	DraggableItem.move_area = get_global_rect()
	drawing_tablet.enabled = true


func close() -> void:
	drawing_tablet.enabled = false
	create_tween().tween_property(self, "modulate:a", 0.0, 0.2).finished.connect(hide)


func _create_draggable_items(inventory: Dictionary) -> void:
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
	demon_summoned.emit(null)
	close()
