class_name DraggableItem extends TextureRect

const TEX_SIZE := 16

signal dragging_finished(where: Vector2)
enum Types {CANDLE, INCENCE, HEART, KNIFE, SILK, FEATHERS}

static var move_area: Rect2

var type := Types.CANDLE:
	set(to):
		type = to
		tooltip_text = (Types.find_key(to) as String).to_snake_case().replace("_", " ")
		if not texture:
			return
		var column := int(type) % 4
		var row := (int(type) - column) / 4
		(texture as AtlasTexture).region = Rect2(
				column * TEX_SIZE, row * TEX_SIZE, TEX_SIZE, TEX_SIZE)

var mouse_in
var click_point := Vector2()
var dragging := false

var shadow: Sprite2D
var highlight: Sprite2D


static func create(type: Types) -> DraggableItem:
	var a := load("res://scenes/main_ui/draggable_item.tscn").instantiate() as DraggableItem
	a.type = type
	return a


func _ready() -> void:
	type = type


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and mouse_in:
			dragging = true
			DrawingTablet.dragging_something_else = true
			click_point = get_local_mouse_position()
			add_shadow()
		elif event.is_released():
			dragging = false
			(func(): DrawingTablet.dragging_something_else = false).call_deferred()
			dragging_finished.emit(global_position)
			remove_shadow()


func _physics_process(delta: float) -> void:
	if dragging:
		global_position = (get_global_mouse_position() - click_point).clamp(
			move_area.position, move_area.position + move_area.size - size
		)


func _on_mouse_entered() -> void:
	DrawingTablet.dragging_something_else = true
	mouse_in = true


func _on_mouse_exited() -> void:
	(func(): DrawingTablet.dragging_something_else = false).call_deferred()
	mouse_in = false


func _make_custom_tooltip(for_text: String) -> Object:
	var c := Label.new()
	c.text = for_text
	c["theme_override_font_sizes/font_size"] = 8
	return c


func add_shadow() -> void:
	shadow = Sprite2D.new()
	shadow.texture = preload("res://scenes/main_ui/item_shadow.tres")
	shadow.centered = false
	shadow.show_behind_parent = true
	add_child(shadow)
	shadow.position.y += 12


func remove_shadow() -> void:
	if not is_instance_valid(shadow):
		return
	shadow.queue_free()
	shadow = null


func add_highlight() -> void:
	highlight = Sprite2D.new()
	highlight.texture = texture
	highlight.centered = false
	highlight.material = CanvasItemMaterial.new()
	highlight.material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	highlight.scale = Vector2.ONE * 1.2
	highlight.show_behind_parent = true
	highlight.modulate = Color(0.5, 0.0, 0.5, 0.4)
	add_child(highlight)
	highlight.global_position -= Vector2.ONE * 2.4


func remove_highlight() -> void:
	if not is_instance_valid(highlight):
		return
	highlight.queue_free()
	highlight = null

