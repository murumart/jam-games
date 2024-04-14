class_name BattlerInfo extends MarginContainer

@onready var portrait: TextureRect = %Portrait
@onready var name_label: Label = %NameLabel
@onready var health_bar: ProgressBar = %HealthBar
@onready var demon_stats: HFlowContainer = %DemonStats


func set_health(health: float) -> void:
	var tw := create_tween()
	tw.tween_property(health_bar, "value", health, 0.2)


func init_health(health: float, max_health: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = health


func set_demon_name(nomen: String) -> void:
	name_label.text = nomen
	_gen_portrait()


func display_demon_stats(stats: DemonStats) -> void:
	demon_stats.get_children().map(func(a): a.hide(); a.queue_free())
	if not stats:
		return
	var stat_cont := preload("res://scenes/main_ui/demon_stat_display.tscn")
	for x in stats.STATS.keys():
		if x == &"health":
			continue
		if stats.get(x) > 0:
			var s := stat_cont.instantiate() as DemonStatDisplay
			demon_stats.add_child(s)
			s.set_display(x, stats.get(x))


func _gen_portrait() -> void:
	var imgsize := 16
	var img := Image.create(imgsize, imgsize, false, Image.FORMAT_RGBA8)
	img.fill(Color.BLACK)
	for i in range(2, 4):
		add_pixel(img, Color(randf(), randf(), randf()), Vector2i(
				randf() * imgsize / 2, randf() * imgsize), 0)
	portrait.texture = ImageTexture.create_from_image(img)


func add_pixel(img: Image, color: Color, pos: Vector2i, depth: int) -> void:
	if depth > 10:
		return
	img.set_pixel(pos.x, pos.y, color)
	img.set_pixel(img.get_size().x - pos.x - 1, pos.y, color)
	if randf() < 0.25:
		color.h = wrapf(color.h + randf(), 0.0, 1.0)
	elif randf() < 0.26:
		color = color.darkened(randf() * 0.5)
	pos.x += randi_range(-10, color.to_rgba32() / 100000000)
	pos.y += randi_range(-10, color.to_abgr32() / 100000000)
	pos = pos.clamp(Vector2i.ZERO, Vector2i(img.get_size().x / 2, img.get_size().y) - Vector2i.ONE)
	for i in randi_range(1, 2):
		add_pixel(img, color, pos, depth + 1)
