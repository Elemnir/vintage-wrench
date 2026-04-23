class_name MainMenu
extends PanelContainer

const ADD_BUTTON_TEXTURE: Texture2D = preload("res://assets/icons/Add.svg")

const MODINFO_SCENE = preload("res://components/edit_mod_info.tscn")

const LABEL_TRAITS = "Traits"
const LABEL_CLASSES = "Classes"

const MODINFO_PATH = "/modinfo.json"
const CLASSES_PATH = "/config/characterclasses.json"
const TRAITS_PATH = "/config/traits.json"
const ENLANG_PATH = "/lang/en.json"

@onready var mod_structure = %ModStructure
@onready var editor_tabs = %EditorTabs

func _ready():
	var root = mod_structure.create_item()
	var modinfo = root.create_child()
	modinfo.set_text(0, "Mod Details")
	modinfo.set_metadata(0, MODINFO_SCENE.instantiate())
	for label in [LABEL_TRAITS, LABEL_CLASSES]:
		var item = root.create_child()
		item.set_text(0, label)
		item.add_button(0, ADD_BUTTON_TEXTURE)
		item.set_selectable(0, false)


func _on_mod_structure_item_selected():
	var edit_scene = mod_structure.get_selected().get_metadata(0)
	if not editor_tabs.has_node(edit_scene.get_path()):
		editor_tabs.add_child(edit_scene)
	editor_tabs.current_tab = edit_scene.get_index()


func _on_mod_structure_button_clicked(item, _column, _id, _mouse_button_index):
	var new_item = item.create_child()
	match item.get_text(0):
		LABEL_TRAITS:
			pass
		LABEL_CLASSES:
			pass
