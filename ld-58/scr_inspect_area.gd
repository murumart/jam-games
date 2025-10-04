class_name InspectArea extends Area2D

signal inspected

@export_multiline var lines: PackedStringArray
@export var dial: Array[DialogueLine]
@export var dialogue_box: DialogueBox


func _ready() -> void:
	area_entered.connect(_inspected.unbind(1))
	monitoring = true
	monitorable = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(3, true)


func _inspected() -> void:
	inspected.emit()
	if not is_instance_valid(dialogue_box):
		if not lines.is_empty() or not dial.is_empty():
			push_error("no dialogue box but some dialogue data exists")
		return
	if not lines.is_empty():
		var dlg := DialogueBuilder.new()
		for l in lines:
			dlg.al(l)
		await dlg.speak(dialogue_box)
	if not dial.is_empty():
		await dialogue_box.speak(dial)
