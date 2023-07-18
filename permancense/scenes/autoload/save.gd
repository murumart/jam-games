extends Node

const SAVE_PATH := "user://save"


var E := {}


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			save_file()
			get_tree().quit()
		NOTIFICATION_READY:
			load_file()


func save_file() -> void:
	var tosave := var_to_bytes(E)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(tosave)
	file.close()


func load_file() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		E = {}
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	print(file.get_length())
	if file.get_length() < 2:
		E = {}
		return
	var fromsave := file.get_var(false) as PackedByteArray
	E = bytes_to_var(fromsave)
	file.close()


func ses(k: StringName, v: Variant) -> void:
	E[k] = v


func ges(k: StringName, d: Variant = null) -> Variant:
	return E.get(k, d)


func appes(k: StringName, v: Variant) -> void:
	var array := E.get(k, []) as Array
	array.append(v)
	E[k] = array

