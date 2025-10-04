class_name DialogueBuilder extends Resource

var _dial: Array[DialogueLine]


func speak(box: DialogueBox) -> void:
	await box.speak(_dial)


func al(txt: String) -> DialogueLine:
	var line := DialogueLine.mk(txt)
	_dial.append(line)
	return line


func reset() -> void:
	_dial.clear()


func get_dial() -> Array[DialogueLine]:
	return _dial
