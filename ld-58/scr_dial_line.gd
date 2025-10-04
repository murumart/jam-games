class_name DialogueLine extends Resource

@export_multiline var text: String


static func mk(txt: String) -> DialogueLine:
	var line := DialogueLine.new()
	line.text = txt
	return line
