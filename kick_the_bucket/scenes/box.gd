class_name Box extends StaticBody2D


@onready var sprite: Sprite2D = $Sprite2D
var open := false
var PICKUP := preload("res://scenes/pickups/pickup.tscn")
var STORED : PackedScene = null
@export var stored_item : Item


func hurt(_amt: float) -> void:
	if open: return
	await get_tree().process_frame
	GLB.play_sound(preload("res://sounds/open_box.ogg"))
	open = true
	sprite.region_rect.position.y = 64
	if not STORED:
		if not stored_item:
			GLB.flies(global_position + Vector2(32, 32))
		else:
			var pu := PICKUP.instantiate() as Pickup
			pu.item = stored_item
			pu.global_position = global_position
			pu.start_pos = global_position + Vector2(32, 32)
			add_sibling(pu)
			stored_item = null
	else:
		var stored := STORED.instantiate() as Pickup
		stored.global_position = global_position
		stored.start_pos = global_position + Vector2(32, 32)
		add_sibling(stored)
