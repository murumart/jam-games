class_name Pickup extends Area2D

@export var hp_gain : float = 0
@export var item : Item
var start_pos := Vector2()
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	if not item:
		queue_free()
		return
	
	sprite.texture = item.texture
	if item.count > 1:
		for i in item.count - 1:
			var sprite2 := sprite.duplicate()
			add_child(sprite2)
			sprite2.global_position += Vector2(
			randf_range(-10, 10),
			randf_range(-10, 10),
			)
	
	var tw := create_tween()
	tw.tween_property(self, "global_position", start_pos + 
	(Vector2.from_angle(randf_range(-PI, PI)) * 32), 0.3
	).set_trans(Tween.TRANS_CUBIC).from(start_pos)


func pick_up(player: Player) -> void:
	var found := false
	if player.current_weapon == item.name and item.equip:
		player.ammo += item.count
		GUI.display_inventory(player.inventory)
		queue_free()
		return
	for i in player.inventory:
		if i.name == item.name:
			i.count += item.count
			found = true
			break
	if not found:
		player.inventory.append(item)
		item.count = maxi(item.count, 1)
	GUI.display_inventory(player.inventory)
	queue_free()
