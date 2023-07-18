extends Room

var z := 0.0
@onready var socks := [$Sprite2D2, $Sprite2D3, $Sprite2D4]
@onready var socks_amount : int = SAV.ges("socks_found", 0)
@onready var chair: Sprite2D = $Chair
@onready var theend: Sprite2D = $Theend


func _ready() -> void:
	super._ready()
	if SAV.ges("stinky", true):
		for i in socks: i.hide()
	if not SAV.ges("bathroom_has_chair", false): chair.hide()


func _physics_process(delta: float) -> void:
	z = (96 - player.position.y) * 0.08
	player.scale = Vector2(z, z)
	player.rotation = PI
	player.speed = -z * 10


func _on_pipe_interaction_interacted() -> void:
	if not SAV.ges("stinky", true):
		return
	if socks_amount < 1:
		GUI.dialogue("stinky. need to plug up with socks")
		SAV.ses("sock_idea_gotten", true)
	elif socks_amount > 3 and not SAV.ges("bathroom_has_chair", false):
		if not SAV.ges("has_chair", false):
			GUI.dialogue("i cant reach. need chair. look for chair")
	elif socks_amount > 3 and SAV.ges("bathroom_has_chair", false):
		SAV.ses("stinky", false)
		for i in [$Stinky, $Stinky2, $Stinky3]: i.queue_free()
		for i in socks:
			i.show()
		player.locked = true
		GLB.play_music(preload("res://music/end.ogg"))
		var tw := create_tween()
		theend.show()
		tw.tween_property(theend, "modulate:a", 1.0, 10.0).from(0.0)
	
	if SAV.ges("has_chair", false):
		SAV.ses("bathroom_has_chair", true)
		chair.show()
		SAV.ses("has_chair", false)
		player.get_node("ChairSPrite").visible = false
