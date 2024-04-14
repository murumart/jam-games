class_name DemonGenerator extends Node2D

static var _parts := {}


func generate(demon_stats: DemonStats) -> Battler:
	DemonGenerator.load_bodypart_files()
	var battler := Battler.new()
	battler.demon_stats = demon_stats
	var torso := BodypartMarker.new()
	torso.type = &"torso"
	battler.add_child(torso)
	battler.ready.connect(func(): torso.start_generating(_parts, demon_stats))
	return battler


static func load_bodypart_files() -> void:
	if not _parts.is_empty():
		return
	_parts = Dir.load_demon_parts()


