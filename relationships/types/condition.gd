class_name Condition extends Resource

var _parent: Node
@export var node: NodePath
@export var property_path: StringName
@export var any_true_value: Array


func is_true() -> bool:
	assert(is_instance_valid(_parent), "Condition needs to be used under a BoolChecker node")
	var found_node := _parent.get_node_or_null(node)
	if not found_node:
		print(node)
		printerr(self, ": node not found")
		return false
	var ixp := NodePath(property_path)
	for value in any_true_value:
		if found_node.get_indexed(ixp) == value:
			return true
	return false
