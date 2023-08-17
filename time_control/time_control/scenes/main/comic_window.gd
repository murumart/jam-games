class_name ComicWindow extends Control

const PAGE_PATH := "res://scenes/pages/%s.tscn"

var current_page : Page
var current_page_nr := 1
var chosen : StringName = ""
@onready var page_text: RichTextLabel = $ScrollContainer/Center/PageText
@onready var page_title: RichTextLabel = $ScrollContainer/Center/PageTitle
@onready var content: Control = $ScrollContainer/Center/Content
@onready var next_page_container: HBoxContainer = $ScrollContainer/Center/NextPageContainer


func _ready() -> void:
	load_page(1)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_backspace") or \
	event.is_action_pressed("ui_left"):
		if not current_page.previous_page == current_page_nr:
			load_page(current_page.previous_page)
			page_title.text = "Moving back in time"
		else:
			page_title.text = "There's no need to go back from here."
	elif event.is_action_pressed("ui_right"):
		if current_page.next_choices.size() == 1:
			_choice_received(current_page.next_choices[0])


func load_page(nr: int) -> void:
	current_page_nr = nr
	var path := PAGE_PATH % nr
	var loaded_page : Page
	if ResourceLoader.exists(path):
		loaded_page = load(path).instantiate() as Page
	else:
		loaded_page = preload("res://scenes/pages/base_page.tscn").instantiate() as Page
		if nr in StoredPages.pages.keys():
			loaded_page.load_from_storage(nr)
	for c in next_page_container.get_children():
		c.queue_free()
	load_from_page(loaded_page)
	for i in loaded_page.next_choices:
		var button := Button.new()
		next_page_container.add_child(button)
		button.text = i
		button.pressed.connect(_choice_received.bind(i))


func load_from_page(page: Page) -> void:
	var old_page := current_page
	page_text.text = page.text
	page_title.text = chosen
	current_page = page
	if old_page == current_page: return
	if is_instance_valid(old_page):
		old_page.queue_free()
	content.add_child(page)


func _choice_received(choice: StringName) -> void:
	match choice:
		_:
			chosen = choice
			var nc := current_page.next_choices
			var np := current_page.next_pages
			load_page(np[nc.find(choice)])

