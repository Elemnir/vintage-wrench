class_name MainMenu
extends PanelContainer

const ADD_BUTTON_TEXTURE: Texture2D = preload("res://assets/icons/Add.svg")
const ENLANG_PATH = "/lang/en.json"
const MODINFO_LABEL = "Mod Info"
const MODINFO_PATH = "/modinfo.json"
const MODINFO_SCENE = preload("res://components/edit_mod_info.tscn")

const MOD_SUBDIRS: Array[String] = [
	"/config",
	"/lang",
]

var _mod_info: TreeItem
var _mod_path: String
var _mod_sections: Dictionary[String, TreeItem] = {}

var _mod_types: Dictionary = {
	"Traits": CharacterTraitMod,
	"Classes": CharacterClassMod,
}

@onready var mod_structure = %ModStructure
@onready var editor_tabs = %EditorTabs

func _ready():
	var tabs: TabBar = editor_tabs.get_tab_bar()
	tabs.set_tab_close_display_policy(TabBar.CloseButtonDisplayPolicy.CLOSE_BUTTON_SHOW_ALWAYS)
	tabs.tab_close_pressed.connect(_on_editor_tabs_button_pressed)
	var root = mod_structure.create_item()
	_mod_info = root.create_child()
	_mod_info.set_text(0, MODINFO_LABEL)
	_mod_info.set_metadata(0, MODINFO_SCENE.instantiate())
	for label in _mod_types:
		var item = root.create_child()
		item.set_text(0, label)
		item.add_button(0, ADD_BUTTON_TEXTURE)
		item.set_selectable(0, false)
		_mod_sections[label] = item


func export():
	var info = get_mod_info()
	var apath = "assets/%s" % info.code
	var wd = DirAccess.open(_mod_path)
	FileAccess.open(
		wd.get_current_dir() + MODINFO_PATH, FileAccess.WRITE
	).store_string(JSON.stringify(info, "  "))
	for subdir in MOD_SUBDIRS:
		if not wd.dir_exists(apath + subdir):
			wd.make_dir_recursive(apath + subdir)
	for label in _mod_types:
		FileAccess.open(
			wd.get_current_dir() + '/' + apath + _mod_types[label].get_file_path(),
			FileAccess.WRITE
		).store_string(get_section_items_json(label))
	FileAccess.open(
		wd.get_current_dir() + '/' + apath + ENLANG_PATH, FileAccess.WRITE
	).store_string(get_lang_json())


func import():
	var wd = DirAccess.open(_mod_path)
	var info = load_mod_info(
		JSON.parse_string(FileAccess.open(
			wd.get_current_dir() + MODINFO_PATH, FileAccess.READ
		).get_as_text())
	)
	var apath = "/assets/%s" % info.code
	var lang_data = JSON.parse_string(FileAccess.open(
		wd.get_current_dir() + apath + ENLANG_PATH, FileAccess.READ
	).get_as_text())
	for label in _mod_types:
		load_section_items(
			label, 
			JSON.parse_string(FileAccess.open(
				wd.get_current_dir() + apath + _mod_types[label].get_file_path(),
				FileAccess.READ
			).get_as_text()),
			lang_data
		)
	

func get_lang_json() -> String:
	var lang_dict = {}
	for section in _mod_sections:
		for item in _mod_sections[section].get_children():
			lang_dict.merge(item.get_metadata(0).get_loaded_object.get_lang_entry())
	return JSON.stringify(lang_dict, "  ")


func get_mod_info() -> ModInfo:
	return _mod_sections[MODINFO_LABEL].get_metadata(0).get_loaded_object().get_data_entry()


func get_section_items_json(section_name: String) -> String:
	var items = []
	for item in _mod_sections[section_name].get_children():
		items.append(item.get_metadata(0).get_loaded_object().get_data_entry())
	return JSON.stringify(items, "  ")


func load_mod_info(data: Dictionary) -> ModInfo:
	var info: ModInfo = ModInfo.load_from_data(data)
	_mod_sections[MODINFO_LABEL].get_metadata(0).load_using_object(info)
	return info


func load_section_items(section: String, data: Array[Dictionary], lang: Dictionary):
	for item in data:
		var new_entry = _mod_sections[section].create_child()
		var new_scene = _mod_types[section].get_edit_scene().instantiate()
		new_entry.set_metadata(0, new_scene)
		new_scene.code_changed.connect(_on_edit_view_code_changed.bind(new_entry))
		new_scene.name_changed.connect(_on_edit_view_name_changed.bind(new_entry))
		new_scene.load_using_object(_mod_types[section].load_from_data(item, lang))


func _on_mod_structure_item_selected():
	var edit_scene = mod_structure.get_selected().get_metadata(0)
	if not edit_scene.is_inside_tree():
		editor_tabs.add_child(edit_scene)
		editor_tabs.set_tab_title(edit_scene.get_index(), edit_scene.get_display_name())
	editor_tabs.current_tab = edit_scene.get_index()


func _on_mod_structure_button_clicked(item, _column, _id, _mouse_button_index):
	var mod_type = _mod_types[item.get_text(0)]
	var new_item = item.create_child()
	new_item.set_text(0, mod_type.get_default_name())
	new_item.set_tooltip_text(0, mod_type.get_default_code())
	new_item.set_metadata(0, mod_type.get_edit_scene().instantiate())
	new_item.get_metadata(0).code_changed.connect(
		_on_edit_view_code_changed.bind(new_item)
	)
	new_item.get_metadata(0).name_changed.connect(
		_on_edit_view_name_changed.bind(new_item)
	)


func _on_edit_view_code_changed(new_name: String, item: TreeItem):
	item.set_tooltip_text(0, new_name)
	var edit_scene = item.get_metadata(0)
	if edit_scene.is_inside_tree():
		editor_tabs.set_tab_tooltip(edit_scene.get_index(), new_name)


func _on_edit_view_name_changed(new_name: String, item: TreeItem):
	item.set_text(0, new_name)
	var edit_scene = item.get_metadata(0)
	if edit_scene.is_inside_tree():
		editor_tabs.set_tab_title(edit_scene.get_index(), new_name)


func _on_editor_tabs_button_pressed(tab: int) -> void:
	var editor = editor_tabs.get_tab_control(tab)
	editor.get_loaded_object()
	editor_tabs.remove_child(editor)
