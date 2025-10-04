class_name DialogueBuilder extends Resource

@export_multiline var text_lines: PackedStringArray

var _dial: Array[DialogueLine]


func speak(box: DialogueBox) -> void:
	if not text_lines.is_empty():
		for l in text_lines:
			al(l)
		text_lines.clear()
	box.speak(_dial)


func al(txt: String) -> DialogueLine:
	var line := DialogueLine.mk(txt)
	_dial.append(line)
	return line


func reset() -> void:
	_dial.clear()


func get_dial() -> Array[DialogueLine]:
	return _dial
