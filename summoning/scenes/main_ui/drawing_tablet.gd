class_name DrawingTablet extends Panel

enum DrawingModes {BLOOD, SOOT}

static var dragging_something_else := false

var enabled := false
var blood := {}
var soot := {}
var draw_into := {
	DrawingModes.BLOOD: blood,
	DrawingModes.SOOT: soot,
}
var drawing_mode := DrawingModes.BLOOD
var saved_line_start := Vector2()
var line_start := Vector2()
var line_end := Vector2()

var items := []

@onready var dbg := $"../../../../../../../../../debug"

func _input(event: InputEvent) -> void:
	if dragging_something_else:
		return
	if enabled and event is InputEventMouse and not dragging_something_else\
	and get_rect().has_point(get_local_mouse_position()):
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			draw_into[drawing_mode][(Vector2i(get_local_mouse_position()))] = true
			queue_redraw()
			if not line_start:
				line_start = get_local_mouse_position()
		elif event.is_released():
			saved_line_start = line_start if line_start else saved_line_start
			line_end = get_local_mouse_position() if line_start else line_end
			line_start = Vector2()
			queue_redraw()


func _draw() -> void:
	_draw_lines(blood, Color.RED)
	_draw_lines(soot, Color.BLACK)
	dbg.text = JSON.stringify(circle_measurements()).replace(",", ",\n")
	dbg.text += "\n" + JSON.stringify(pentagram_measurements()).replace(",", ",\n")


func _draw_lines(dict: Dictionary, color: Color) -> void:
	var keys := dict.keys()
	for c in keys.size() - 1:
		var start := keys[c] as Vector2
		var end := keys[c + 1] as Vector2
		if start.distance_squared_to(end) < 60:
			draw_line(keys[c], keys[c + 1], color)


func circle_measurements() -> Dictionary:
	var circle_centre := Vector2()
	var clicks := blood.keys()
	for c in clicks:
		circle_centre += Vector2(c)
	circle_centre /= blood.size()
	var average_radius := 0.0
	for c in clicks:
		average_radius += Vector2(c).distance_to(circle_centre)
	average_radius /= blood.size()

	var average_mistake := 0.0
	for c in clicks:
		average_mistake += absf(Vector2(c).distance_to(circle_centre) - average_radius)
	average_mistake /= blood.size()
	if true:
		draw.connect(func():
			pass
			#draw_circle(circle_centre, 3, Color(0, 1, 0, 0.33))
			#draw_arc(circle_centre, average_radius, -PI, PI, 128, Color(0, 1, 1, 0.33))
		, CONNECT_ONE_SHOT)
		queue_redraw()
	return {
		&"circle_centre": circle_centre,
		&"average_radius": average_radius,
		&"average_mistake": average_mistake,
	}


func pentagram_measurements() -> Dictionary:
	var item_centre := Vector2()
	var loop_times := 0
	var candles := items.size()
	for x in items.size():
		var item := items[x] as DraggableItem
		if not item.type == DraggableItem.Types.CANDLE:
			candles -= 1
			continue
		for y in range(x + 1, items.size()):
			var item2 := items[y] as DraggableItem
			if not item2.type == DraggableItem.Types.CANDLE:
				continue
			draw_line(
					item.global_position - global_position + item.size / 2,
					item2.global_position - global_position + item2.size / 2,
					Color(0, 0, 1, 0.2))
			loop_times += 1
		item_centre += item.global_position + item.get_rect().size / 2 - global_position
	item_centre /= candles

	var average_distance := 0.0
	for x in items.size():
		var item := items[x] as DraggableItem
		if not item.type == DraggableItem.Types.CANDLE:
			continue
		average_distance += (
				item.global_position - global_position +
				item.get_rect().size / 2).distance_to(item_centre)
	average_distance /= candles

	var average_mistake := 0.0
	for x in items.size():
		var item := items[x] as DraggableItem
		if not item.type == DraggableItem.Types.CANDLE:
			continue
		average_mistake += absf(
				item_centre.distance_to(
				item.global_position - global_position) - average_distance)
	average_mistake /= candles
	#draw_circle(item_centre, 2, Color.AQUA)
	#draw_arc(item_centre, average_distance, -PI, PI, 128, Color(1, 1, 0, 0.3))
	return {
		&"item_centre": item_centre,
		&"average_distance": average_distance,
		&"average_mistake": remap(maxf(average_mistake, 6.0), 6.0, 10, 0.0, 1.0)
	}


func clear_board() -> void:
	for i in draw_into.values():
		i.clear()


