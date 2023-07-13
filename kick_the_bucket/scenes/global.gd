extends Node

const BLOOD := preload("res://scenes/effects/blood.tscn")
const FLIES := preload("res://scenes/effects/flies.tscn")
const DIR := "user://kick_the_bucket/"
const FNAME := "saved.dat"

var requesting_report := false
var previous_compared_score := -1


func _init() -> void:
	randomize()
	AudioServer.set_bus_volume_db(0, linear_to_db(0.75))
	store_high_score(0)


func play_sound(sound: AudioStream) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = sound
	player.finished.connect(player.queue_free)
	player.play()
	return player


func bleed(pos : Vector2) -> void:
	var blood := BLOOD.instantiate()
	blood.z_index = 1
	blood.global_position = pos
	add_child(blood)


func flies(pos : Vector2) -> void:
	var fliess := FLIES.instantiate()
	fliess.z_index = 1
	fliess.global_position = pos
	add_child(fliess)


func get_save(cat: String, key: String, default = null) -> Variant:
	var cfg := get_cfg()
	cfg.load(DIR + FNAME)
	return cfg.get_value(cat, key, default)


func set_save(cat: String, key: String, value: Variant) -> void:
	var cfg := get_cfg()
	cfg.load(DIR + FNAME)
	cfg.set_value(cat, key, value)
	cfg.save(DIR + FNAME)


func store_high_score(score: int) -> void:
	previous_compared_score = score
	var previous_score := get_save("scores", "high", 0) as int
	if score > previous_score:
		set_save("scores", "high", score)


func get_cfg() -> ConfigFile:
	var cfgf := ConfigFile.new()
	if not DirAccess.dir_exists_absolute(DIR):
		DirAccess.make_dir_absolute(DIR)
	return cfgf


