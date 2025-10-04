extends Node


func switch_level_to_path(path: String) -> void:
	var current_scene := get_tree().root.get_child(-1)
	current_scene.queue_free()

	assert(ResourceLoader.exists(path))
	var new_scene: Node = (load(path) as PackedScene).instantiate()
	#var new_scene_name := new_scene.name
	get_tree().root.add_child.call_deferred(new_scene)
