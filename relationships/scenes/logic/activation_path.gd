class_name ActivationPath extends Line2D

signal activated
signal deactivated

var _is_activated := false

@export var activator: BoolChecker
@export var can_deactivate := false


func test() -> void:
	if activator.is_true():
		activate()
	elif can_deactivate:
		set_activated(false)


func activate() -> void:
	set_activated(true)


func deactivate() -> void:
	set_activated(false)


func set_activated(to: bool) -> void:
	_is_activated = to
	if _is_activated:
		default_color = Color(2.0, 2.0, 2.0)
		activated.emit()
		return
	default_color = Color(1.2, 1.2, 1.2)
	deactivated.emit()
