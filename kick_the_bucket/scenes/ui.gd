extends CanvasLayer

signal death_message_finished()

@onready var healthbar: ProgressBar = $Control/Bars/Health/ProgressBar
@onready var shieldbar: Label = $Control/Bars/Shield/Progress
@onready var ammobar: Label = $Control/Bars/Ammo/Progress

@onready var pivot: Node2D = $Control/CenterContainer/Control/Pivot
@onready var death_message: VBoxContainer = $Control/DeathMessage
@onready var true_death_message: Label = $Control/TrueDeathMessage
@onready var bars: VBoxContainer = $Control/Bars
@onready var status: VBoxContainer = $Control/Status
@onready var items: ItemList = $Control/Items
@onready var ghost_timer_label: Label = $Control/GhostTimerLabel

var mouse_over_inventory := false


func _ready() -> void:
	reset()
	items.mouse_entered.connect(func(): mouse_over_inventory = true)
	items.mouse_exited.connect(func(): mouse_over_inventory = false)


func reset() -> void:
	death_message.hide()
	true_death_message.hide()
	enable_bucket_pivot(false)
	bars.hide()
	status.hide()
	items.hide()
	ghost_timer_label.hide()
	ghost_timer_label.modulate = Color.WHITE


func set_hp(current: float, maxhp := 20.0) -> void:
	healthbar.value = current
	healthbar.max_value = maxhp


func set_shield(current: float) -> void:
	shieldbar.text = str(roundi(current * 100))


func set_ammo(current: int) -> void:
	ammobar.text = str(current)
	ammobar.get_parent().visible = bool(current and not current >= 1000)


func set_loading(to: bool) -> void:
	$Control/Status/Loading.visible = to


func set_bucket_pivot(to: Vector2) -> void:
	pivot.look_at(to)


func enable_bucket_pivot(to: bool) -> void:
	pivot.visible = to


func set_room(to: int) -> void:
	$Control/Status/RoomLabel.text = "room " + str(to)


func set_ghost_timer_label(to: float) -> void:
	ghost_timer_label.visible = to > -1
	ghost_timer_label.text = str("TIME LEFT: ", roundf(to))
	if to < 10:
		ghost_timer_label.modulate = Color(0.98951572179794, 1, 0.72693240642548)
	if to < 3:
		ghost_timer_label.modulate = Color(0.97786575555801, 0, 0.13669162988663)


func show_death_message() -> void:
	death_message.show()
	death_message.modulate.a = 1.0
	var tw := create_tween()
	for label in death_message.get_children():
		label = label as Label
		label.modulate.a = 0.0
		tw.tween_property(label, "modulate:a", 1.0, 2.0).from(0.0)
	tw.tween_callback(emit_signal.bind("death_message_finished"))


func hide_death_message():
	var tw := create_tween()
	tw.tween_property(death_message, "modulate:a", 0.0, 2.0).from(1.0)
	tw.tween_callback(death_message.hide)


func show_true_death_message() -> void:
	var center_container: CenterContainer = $Control/CenterContainer
	status.hide()
	bars.hide()
	enable_bucket_pivot(false)
	death_message.hide()
	var tw := create_tween()
	true_death_message.show()
	tw.tween_property(true_death_message, "modulate:a", 1.0, 2.0).from(0.0)


func display_inventory(inventory: Array[Item]) -> void:
	items.clear()
	for i in inventory.size():
		var item := inventory[i]
		items.add_item(item.name + " x" + str(item.count), item.texture)

