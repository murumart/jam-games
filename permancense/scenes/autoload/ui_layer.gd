extends CanvasLayer

signal dial_opened
signal dial_closed

var open := false
@onready var dialbox: ColorRect = $Dialbox
@onready var textbox: RichTextLabel = $Dialbox/RichTextLabel


func dialogue(string: String) -> void:
	print("hi")
	print(string)
	dial_opened.emit()
	set_deferred("open", true)
	dialbox.show()
	textbox.text = string
	textbox.visible_characters = 0
	var tw := create_tween()
	tw.tween_property(textbox, "visible_characters", string.length(), 0.03 * string.length())


func _unhandled_input(event: InputEvent) -> void:
	if open:
		if event.is_action_pressed("ui_accept"):
			dial_closed.emit()
			dialbox.hide()
			open = false
