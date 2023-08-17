class_name Page extends Control

@export_multiline var text := ""

@export var next_choices : Array[StringName] = []
@export var next_pages : Array[int] = []
@export var previous_page : int = 0
@export var play_music : AudioStream


func _ready() -> void:
	GLB.play_music(play_music)


# works only on base_page
func load_from_storage(page_nr: int) -> void:
	assert(get_meta("base"), "not base_page")
	if not get_meta("base"): return
	var page := StoredPages.StoredPage.new(page_nr)
	text = page.text
	next_choices = page.next_choices
	next_pages = page.next
	previous_page = page.previous
	play_music = page.music
	$Picture.texture = load(StoredPages.IMAGE_PATH % page.image)
