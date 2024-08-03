class_name DemonGenerator extends Node2D

static var _parts := {}


func generate(demon_stats: DemonStats) -> Battler:
	print("stats: ", demon_stats)
	DemonGenerator.load_bodypart_files()
	var battler := Battler.new()
	var torso := BodypartMarker.new()
	torso.type = &"torso"
	battler.add_child(torso)
	torso.finished.connect(func(stats: DemonStats):
		stats.validate()
		battler.set_stats(stats)
	)
	battler.ready.connect(func(): torso.start_generating(_parts, demon_stats))
	battler.demon_name = _get_demon_name()
	return battler


static func load_bodypart_files() -> void:
	if not _parts.is_empty():
		return
	_parts = Dir.load_demon_parts()


func _get_demon_name() -> String:
	var n := ""
	for i in randi_range(5, 10):
		n += "wirioqwoiwquotskd"[randi() % 17]
	return n

