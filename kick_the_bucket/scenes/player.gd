class_name Player extends CharacterBody2D

signal died(as_ghost : bool)
signal resurrected()

var health := 20.0: set = set_health
var max_health := 20.0
var shield := 5.0:
	set(to):
		shield = to
		GUI.set_shield(to)

var input := Vector2()
var speed := 200

const FRICTION := 1600
const ACCEL := 2000

const PROJECTILES_LOAD := {
	&"sword": preload("res://scenes/projectiles/sword.tscn"),
	&"fireball": preload("res://scenes/projectiles/fireballfriend.tscn"),
	&"sniper": preload("res://scenes/projectiles/sniper_rifle.tscn")
}
var current_weapon := &"sword"
var ammo := 0:
	set(to):
		ammo = to
		GUI.set_ammo(to)
const SWORD := preload("res://items/sword.tres")
const BUCKET := preload("res://scenes/bucket.tscn")

var ghost := false: set = set_ghost
var locked := false
var bucket_searching := false
var bucket : Node2D
var over := false

@onready var anim := $CharacterAnimation as AnimatedSprite2D
@onready var step_sound: AudioStreamPlayer = $StepSound
@onready var step_sound_timer: Timer = $StepSound/StepSoundTimer
@onready var ghost_timer: Timer = $GhostTimer
var step_delay := 1.0
@onready var tutorial: Sprite2D = $Tutorial

var invincibility := 1.0


var tutorial_progress : int = 0:
	set(to):
		tutorial_progress = to
		if to == 0:
			tutorial.texture = preload("res://art/ui/movement_tutorial.png")
		elif to == 1:
			tutorial.texture = preload("res://art/ui/clicking_tutorial.png")
		else:
			tutorial.hide()

var inventory : Array[Item] = []


func _ready() -> void:
	step_sound_timer.timeout.connect(step_sounds)
	GUI.set_hp(health, max_health)
	shield = shield
	ammo = 99999999999
	GUI.items.item_clicked.connect(_on_item_clicked)
	GUI.display_inventory(inventory)
	ghost_timer.timeout.connect(_on_ghost_timeout)
	tutorial_progress = 0
	# called after main.ready
	await get_tree().process_frame
	GUI.items.show()


var ghost_life := 0.0
func _physics_process(delta: float) -> void:
	invincibility -= delta
	if not locked:
		input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if input:
			tutorial_progress += 1 if tutorial_progress == 0 else 0
		
		if not ghost:
			velocity = velocity.move_toward(Vector2(), FRICTION * delta)
		else:
			velocity = velocity.move_toward(Vector2(), delta * FRICTION * 0.15)
		if input:
			velocity.x = move_toward(velocity.x, input.x * speed, ACCEL * delta)
			velocity.y = move_toward(velocity.y, input.y * speed, ACCEL * delta)
		
		move_and_slide()
	if not ghost:
		if input.x and not input.y : 
			anim.play("walk_left")
			anim.scale.x = int(input.x < 0) * 2 - 1
		else:
			anim.play("walk_up" if input.y < 0 else "walk_down")
		anim.speed_scale = velocity.length() * 0.01
		step_delay = minf(20.0 / velocity.length(), 0.3)
		if input:
			if step_sound_timer.is_stopped():
				step_sound_timer.start(step_delay)
		else:
			step_sound_timer.stop()
		
		if Input.is_action_just_pressed("click") and not GUI.mouse_over_inventory:
			tutorial_progress += 1 if tutorial_progress == 1 else 0
			if ammo > 0:
				var projectile := PROJECTILES_LOAD.get(current_weapon
				).instantiate() as Projectile
				projectile.direction = global_position.direction_to(
				get_global_mouse_position())
				projectile.global_position = self.global_position
				add_sibling(projectile)
				ammo -= 1
				GLB.play_sound(preload("res://sounds/sword.ogg"))
	if ghost:
		ghost_life += delta
		if not locked and not over:
			GUI.set_ghost_timer_label(ghost_timer.time_left)
	if bucket_searching:
		GUI.set_bucket_pivot(bucket.get_global_transform_with_canvas().origin)
	
	if Input.is_action_just_pressed("ui_page_up") and OS.has_feature("editor"):
		get_parent().rooms_explored += 1
	
#	$Label.text = "%s
#%s" % [global_position.round(), (global_position / 64).floor()]
#	if Input.is_action_just_pressed("ui_accept"): ghost = !ghost


func hurt(amount: float) -> void:
	invincibility += 0.05
	if invincibility > 0: return
	if over: return
	if ghost_life > 0.2:
		over = true
		ghost_timer.stop()
		died.emit(true)
		return
	var shield_left := shield - amount
	shield = maxf(shield_left, 0.0)
	if shield_left < 0:
		health += shield_left
	GLB.play_sound(preload("res://sounds/hit_player.ogg"))
	GLB.bleed(global_position)
	if health <= 0:
		death()
		died.emit(false)


func set_health(to: float) -> void:
	health = to
	GUI.set_hp(health, max_health)


func set_ghost(to: bool) -> void:
	ghost = to
	anim.visible = not to
	$GhostAnimation.visible = to
	$Hitbox.set_collision_layer_value(2, not to)
	$Hitbox.set_collision_layer_value(5, to)
	$Hitbox.set_collision_layer_value(5, to)
	$Pickuper.set_collision_mask_value(4, not to)
	set_collision_mask_value(1, not to)
	set_collision_mask_value(3, not to)
	set_collision_layer_value(2, not to)
	set_collision_layer_value(5, to)
	set_collision_mask_value(6, to)
	ghost_life = 0.0


func step_sounds() -> void:
	if ghost: return
	step_sound_timer.start(step_delay)
	step_sound.play()


func death() -> void:
	invincibility += 0.3
	ghost = true
	locked = true
	inventory.clear()
	GUI.display_inventory(inventory)
	GUI.items.hide()
	hide()
	var bucket_spawn := BUCKET.instantiate()
	await get_tree().process_frame
	add_sibling(bucket_spawn)
	bucket_spawn.global_position = global_position
	bucket = bucket_spawn
	GLB.play_sound(preload("res://sounds/bucket.ogg"))


func use_item(i: int) -> void:
	var item := inventory[i]
	item.use(self)
	if item.count == 0: inventory.remove_at(i)
	if item.equip and not item.name == &"sword" and not in_inventory_s(&"sword"):
		inventory.push_front(SWORD.duplicate())
	elif item.name == &"sword":
		ammo = 99999999999
	GUI.display_inventory(inventory)


func use_item_s(itemname: StringName) -> void:
	for i in inventory.size():
		var item := inventory[i]
		if item.name == itemname:
			use_item(i)
			return


func in_inventory_s(itemname: StringName) -> bool:
	for i in inventory:
		if i.name == itemname:
			return true
	return false


func _on_item_clicked(index: int, _at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		use_item(index)


func _on_pickuper_area_entered(area: Area2D) -> void:
	if not area is Pickup: return
	area = area as Pickup
	area.pick_up(self)


func _on_ghost_timeout() -> void:
	hurt(1)
