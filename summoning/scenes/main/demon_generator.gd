class_name DemonGenerator extends Node2D

static var _parts := {}


func generate(demon_stats: DemonStats) -> void:
	DemonGenerator.load_bodypart_files()
	var torso := BodypartMarker.new()
	torso.type = &"torso"
	add_child(torso)
	torso.start_generating(DemonGenerator._parts, demon_stats)


static func load_bodypart_files() -> void:
	if not _parts.is_empty():
		return
	_parts = Dir.load_demon_parts()


