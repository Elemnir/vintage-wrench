class_name SelectionManager
extends VSplitContainer

const ADD_BUTTON_TEXTURE: Texture2D = preload("res://assets/icons/Add.svg")
const DEL_BUTTON_TEXTURE: Texture2D = preload("res://assets/icons/Remove.svg")

@export var available_text: String = "Available:"
@export var selected_text: String = "Selected:"

# Pointers to the Tree roots for simplicity
var _available: TreeItem
var _selected: TreeItem

@onready var available = %AvailableOptions
@onready var selected = %SelectedOptions
@onready var available_label = %AvailableLabel
@onready var selected_label = %SelectedLabel


func _ready():
	_available = available.create_item()
	_selected = selected.create_item()
	available_label.text = available_text
	selected_label.text = selected_text


func find_or_create_category(
	parent: TreeItem, text: String, text_col: int = 0, sep: String = "-"
) -> TreeItem:
	for part in text.split(sep, false).slice(0,-1):
		parent = find_or_create_child_with_text(parent, part, text_col)
		parent.set_selectable(0, false)
		parent.set_collapsed(true)
	return parent


func find_or_create_child_with_text(
	parent: TreeItem, text: String, column: int = 0
) -> TreeItem:
	for child in parent.get_children():
		if child.get_text(column) == text:
			return child
	var rval = parent.create_child()
	rval.set_text(column, text)
	return rval


func get_selected_options() -> Array[String]:
	var rval: Array[String] = []
	var queue: Array[TreeItem] = [_selected]
	while queue:
		var current = queue.pop_back()
		for child in current.get_children():
			if child.get_child_count() > 0:
				queue.push_back(child)
			else:
				rval.push_back(child.get_text(0))
	return rval


func load_selected_options(selections: Array):
	for item in selections:
		var parent = find_or_create_category(_available, item)
		set_option_selected(find_or_create_child_with_text(parent, item))


func make_options_available(options: Array[String]):
	for item in options:
		var parent = find_or_create_category(_available, item)
		var new_item = find_or_create_child_with_text(parent, item)
		new_item.add_button(0, ADD_BUTTON_TEXTURE)


func set_option_selected(avail_option: TreeItem):
	var selection = find_or_create_child_with_text(
		_selected, avail_option.get_text(0), 0
	)
	if selection.get_button_count(0) == 0:
		selection.add_button(0, DEL_BUTTON_TEXTURE)
	avail_option.set_button_disabled(0, 0, true)
	avail_option.set_selectable(0, false)
	
	
func set_option_unselected(selection: TreeItem):
	var ident = selection.get_text(0)
	var avail_option = find_or_create_child_with_text(
		find_or_create_category(_available, ident), ident
	)
	avail_option.set_selectable(0, true)
	avail_option.set_button_disabled(0, 0, false)
	selection.free()


func _on_available_options_button_clicked(item, _column, _id, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		set_option_selected(item)

func _on_available_options_item_activated():
	set_option_selected(available.get_selected())
	
func _on_selected_options_button_clicked(item, _column, _id, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		set_option_unselected(item)

func _on_selected_options_item_activated():
	set_option_unselected(selected.get_selected())
