class_name DemonStatDisplay extends PanelContainer

@onready var label: Label = $Label
@onready var progress_bar: ProgressBar = $ProgressBar


func set_display(stat_name: StringName, value: float) -> void:
	label.text = str(stat_name.to_snake_case().replace("_", ""), " lvl ", value)
	progress_bar.value = value
