class_name LevelTransition

# copied from greg agin

# instead of get_tree().change_scene() or whatever
static func change_scene_to(tree: SceneTree, path: String, options := {}) -> void:
	get_current_scene(tree).queue_free()
	var free_us := tree.get_nodes_in_group("free_on_scene_change")
	if options.get("free_those_nodes", true):
		for node in free_us:
			node.call_deferred("queue_free")
	await tree.process_frame
	var new_scene: Node = load(path).instantiate()
	tree.root.call_deferred("add_child", new_scene, false)
	if new_scene.has_method("_option_init"):
		new_scene._option_init(options)


# this should be a default gdscript function cmon
# turns out it kinda is already. damn
static func get_current_scene(tree: SceneTree) -> Node:
	#return get_tree().current_scene
	return tree.root.get_child(-1)


# change level with fancy fade
static func level_transition(tree: SceneTree, path: String, op := {}) -> void:
	var fadetime: float = op.get("fade_time", 0.4)
	change_scene_to(tree, path, op)
