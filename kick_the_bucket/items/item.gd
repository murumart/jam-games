class_name Item extends Resource

@export var name := &""
@export var texture : Texture2D
@export var count := 1
@export_group("Uses")
@export var healing := 0.0
@export var shield := 0.0
@export var equip := false


func use(player: Player) -> void:
	count -= 1
	
	player.health = minf(player.health + healing, player.max_health)
	if healing > 0:
		GLB.play_sound(preload("res://sounds/heal.ogg"))
	if equip:
		player.current_weapon = name
		player.ammo = count + 1
		count = 0
	if shield > 0:
		player.shield += shield


func set_count(x: int) -> Item:
	count = x
	return self
