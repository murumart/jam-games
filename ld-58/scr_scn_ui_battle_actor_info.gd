extends PanelContainer

@onready var name_label: Label = $MarginContainer/VBoxContainer/NameLabel
@onready var health_progress: ProgressBar = $MarginContainer/VBoxContainer/HealthProgress


func display(actor: BattleActor) -> void:
	if not actor.get_parent():
		add_child(actor)
		actor.data_changed.connect(display.bind(actor))
	name_label.text = actor.actor_name
	health_progress.max_value = actor.max_health
	health_progress.value = actor.health
