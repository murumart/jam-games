extends Control

signal _back_pressed
signal _party_member_acted

enum MenuMode {
	TEXT,
	MAIN,
	ATTACK_OPTIONS_ENEMY,
	ATTACK_OPTIONS_ACTION,
	ITEM_CHOICE,
}

@onready var enemies_baseline: HBoxContainer = %EnemiesBaseline

@onready var actor_info_display: HBoxContainer = %ActorInfoDisplay

@onready var buttons: HFlowContainer = %Buttons
@onready var attack_button: Button = %AttackButton
@onready var item_button: Button = %ItemButton
@onready var special_button: Button = %SpecialButton
@onready var log_text: RichTextLabel = %LogText
@onready var attack_options: HBoxContainer = %AttackOptions
@onready var enemy_choice_list: ItemList = %EnemyChoiceList
@onready var attack_mode_choice_list: ItemList = %AttackModeChoiceList
@onready var target_display: PanelContainer = %TargetDisplay
@onready var label: Label = %Label
@onready var item_list: ItemList = %ItemList

@onready var _menu_toplevel := [buttons, log_text, attack_options, item_list]

@onready var deal_damage: AudioStreamPlayer = $Audio/DealDamage
@onready var receive_damage: AudioStreamPlayer = $Audio/ReceiveDamage
@onready var deal_crit: AudioStreamPlayer = $Audio/DealCrit
@onready var receive_crit: AudioStreamPlayer = $Audio/ReceiveCrit
@onready var use_item: AudioStreamPlayer = $Audio/UseItem

var _menu_mode: MenuMode

var party: Array[BattleActor]
var enemies: Array[BattleActor]


# battle flow

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		_back_pressed.emit()


func _loop() -> void:
	while true:
		await _turn()


var _current_acting_party_member: BattleActor
func _turn() -> void:
	for actor in party:
		_current_acting_party_member = actor
		_to_menu(MenuMode.MAIN)
		await _party_member_acted
	await get_tree().create_timer(0.75).timeout
	for i in range(enemies.size() - 1, -1, -1):
		if enemies[i].health <= 0:
			enemies.remove_at(i)
	for actor in enemies:
		await actor.ai_act(party, enemies)
	await get_tree().create_timer(0.75).timeout


# science have mercy on me
func _to_menu(mode: MenuMode) -> void:
	_menu_mode = mode
	for x in _menu_toplevel:
		x.hide()
	for m in _back_pressed.get_connections():
		_back_pressed.disconnect(m.callable)
	for m in enemy_choice_list.item_selected.get_connections():
		enemy_choice_list.item_selected.disconnect(m.callable)
	var cb_to_menu := func() -> void:
		_to_menu(MenuMode.MAIN)
	var cb_display_enemy := func(ix: int) -> void:
		target_display.display(enemies[ix])
	match mode:
		MenuMode.TEXT:
			log_text.show()
		MenuMode.MAIN:
			buttons.show()
			attack_button.grab_focus()
			attack_button.pressed.connect(func() -> void:
				_to_menu(MenuMode.ATTACK_OPTIONS_ENEMY)
			, CONNECT_ONE_SHOT)
			item_button.pressed.connect(func() -> void:
				_to_menu(MenuMode.ITEM_CHOICE)
			, CONNECT_ONE_SHOT)
		MenuMode.ATTACK_OPTIONS_ENEMY:
			attack_mode_choice_list.clear()
			enemy_choice_list.clear()
			enemy_choice_list.item_selected.connect(cb_display_enemy)
			for e in enemies:
				enemy_choice_list.add_item(e.actor_name)
			attack_options.show()
			enemy_choice_list.grab_focus()
			if not enemy_choice_list.is_anything_selected():
				enemy_choice_list.select(0)
				cb_display_enemy.call(0)
			_back_pressed.connect(cb_to_menu, CONNECT_ONE_SHOT)
			enemy_choice_list.item_activated.connect(func(_a: int) -> void:
				_to_menu(MenuMode.ATTACK_OPTIONS_ACTION)
			, CONNECT_ONE_SHOT)
		MenuMode.ATTACK_OPTIONS_ACTION:
			attack_mode_choice_list.clear()
			var enemy_target := enemies[enemy_choice_list.get_selected_items()[0]]
			for i in BattleActor.ATTACK_MODE_NAMES.size():
				var txt := BattleActor.ATTACK_MODE_NAMES[i]
				if (
					enemy_target.vulnerabilities.get(_current_acting_party_member, 0)
					& BattleActor.ATTACK_MODE_ORDER[i]) != 0:
					txt = "!" + txt + "!"
				attack_mode_choice_list.add_item(txt)
			attack_options.show()
			attack_mode_choice_list.grab_focus()
			if not attack_mode_choice_list.is_anything_selected():
				attack_mode_choice_list.select(0)
			_back_pressed.connect(func() -> void:
				_to_menu(MenuMode.ATTACK_OPTIONS_ENEMY)
			, CONNECT_ONE_SHOT)
			attack_mode_choice_list.item_activated.connect(func(of_modes: int) -> void:
				var atk_mode := BattleActor.ATTACK_MODE_ORDER[of_modes]
				_to_menu(MenuMode.TEXT)
				await _current_acting_party_member.attack(enemy_target, atk_mode)
				_party_member_acted.emit()
			, CONNECT_ONE_SHOT)
		MenuMode.ITEM_CHOICE:
			item_list.show()
			item_list.grab_focus()
			if not item_list.is_anything_selected():
				item_list.select(0)
			_back_pressed.connect(cb_to_menu)


func _text_message(txt: String) -> void:
	txt = " *" + txt + "\n"
	log_text.append_text(txt)
	print("ACTION MESSAGE: " + txt)


# constructing battle

func _ready() -> void:
	# cleanup
	for x in actor_info_display.get_children():
		x.queue_free()

	_add_party(BattleActor.construct("fish", 20, 7, 7))

	_add_enemy(preload("res://scn_enemy_crab.tscn").instantiate())
	_add_enemy(preload("res://scn_enemy_crab.tscn").instantiate())
	_add_enemy(preload("res://scn_enemy_crab.tscn").instantiate())

	_to_menu(MenuMode.TEXT)

	_loop()


func _add_party(member: BattleActor) -> void:
	party.append(member)
	member.action_message.connect(_text_message)
	member.crit_attacked.connect(func() -> void:
		deal_crit.play()
		deal_damage.play()
	)
	member.attacked.connect(func() -> void:
		deal_damage.play()
	)
	var display := preload("res://scn_ui_battle_actor_info.tscn").instantiate()
	actor_info_display.add_child(display)
	display.display(member)


func _add_enemy(enemy: BattleActor) -> void:
	enemies.append(enemy)
	enemy.action_message.connect(_text_message)
	enemy.crit_attacked.connect(func() -> void:
		receive_crit.play()
		receive_damage.play()
	)
	enemy.attacked.connect(func() -> void:
		receive_damage.play()
	)
	var ctrl := Control.new()
	ctrl.add_child(enemy)
	enemies_baseline.add_child(ctrl)
