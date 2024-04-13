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
