extends TabContainer

const AUTHOR_SCENE = preload("res://components/author_line.tscn")
const MODINFO_PATH = "/modinfo.json"
const CLASSES_PATH = "/config/characterclasses.json"
const TRAITS_PATH = "/config/traits.json"
const ENLANG_PATH = "/lang/en.json"

@onready var author_section = %AuthorSection
@onready var author_lines: Array[AuthorLine] = [%DefaultAuthorLine]
@onready var file_path_disp = %FilePathDisplay
@onready var trait_editor = %TraitEditor

func _ready():
	%DefaultAuthorLine.add_pressed.connect(_on_author_add)
	%DefaultAuthorLine.del_pressed.connect(_on_author_del)
	

func export():
	var domain = $%DomainNameInput.text
	var apath = "assets/%s" % domain
	var wd = DirAccess.open(file_path_disp.text)
	FileAccess.open(
		wd.get_current_dir() + MODINFO_PATH, FileAccess.WRITE
	).store_string(get_mod_info_json())
	if not wd.dir_exists(apath + '/lang'):
		wd.make_dir_recursive(apath + '/lang')
	if not wd.dir_exists(apath + '/config'):
		wd.make_dir_recursive(apath + '/config')
	FileAccess.open(
		wd.get_current_dir() + '/' + apath + CLASSES_PATH, FileAccess.WRITE
	).store_string(get_char_classes_json())
	FileAccess.open(
		wd.get_current_dir() + '/' + apath + TRAITS_PATH, FileAccess.WRITE
	).store_string(get_char_traits_json())
	FileAccess.open(
		wd.get_current_dir() + '/' + apath + ENLANG_PATH, FileAccess.WRITE
	).store_string(get_lang_json())


#TODO
func import():
	var wd = DirAccess.open(file_path_disp.text)
	load_mod_info_json(
		JSON.parse_string(FileAccess.open(
			wd.get_current_dir() + MODINFO_PATH, FileAccess.READ
		).get_as_text())
	)
	var apath = "/assets/%s" % $%DomainNameInput.text
	var lang_data = JSON.parse_string(FileAccess.open(
		wd.get_current_dir() + apath + ENLANG_PATH, FileAccess.READ
	).get_as_text())
	load_traits_json(
		JSON.parse_string(FileAccess.open(
			wd.get_current_dir() + apath + TRAITS_PATH, FileAccess.READ
		).get_as_text()), lang_data
	)
	load_classes_json(
		JSON.parse_string(FileAccess.open(
			wd.get_current_dir() + apath + CLASSES_PATH, FileAccess.READ
		).get_as_text()), lang_data
	)


func add_author() -> AuthorLine:
	var new_line = AUTHOR_SCENE.instantiate()
	new_line.add_pressed.connect(_on_author_add)
	new_line.del_pressed.connect(_on_author_del)
	author_lines.append(new_line)
	for line in author_lines:
		line.call_deferred("set_delete_enable", true)
	author_section.add_child(new_line)
	return new_line


func get_author_data() -> Array[String]:
	var rval: Array[String] = []
	for line in author_lines:
		rval.append(line.get_author_name())
	return rval


func get_mod_info_json() -> String:
	var modinfo_data = {
		"type": "content",
		"modid": %DomainNameInput.text,
		"name": %PrettyNameInput.text,
		"authors": get_author_data(),
		"description": %DescriptionInput.text,
		"version": %VersionInput.text,
	}
	return JSON.stringify(modinfo_data)


#TODO - Add classes
func get_lang_json() -> String:
	var lang_dict = {}
	for char_trait in trait_editor.traits:
		lang_dict.merge(char_trait.get_lang_entry())
	return JSON.stringify(lang_dict)


#TODO
func get_char_classes_json() -> String:
	var char_classes = []
	return JSON.stringify(char_classes)


func get_char_traits_json() -> String:
	var char_traits = []
	for char_trait in trait_editor.traits:
		char_traits.append(char_trait.get_data_entry())
	return JSON.stringify(char_traits)

func load_mod_info_json(data: Dictionary):
	%DomainNameInput.text = data["modid"]
	%PrettyNameInput.text = data["name"]
	%DescriptionInput.text = data["description"]
	%VersionInput.text = data["version"]
	%DefaultAuthorLine.set_author_name(data["authors"][0])
	for author in data["authors"].slice(1):
		var new = add_author()
		new.set_author_name(author)

#TODO
func load_classes_json(data: Array, lang: Dictionary):
	pass
	
func load_traits_json(data: Array, lang: Dictionary):
	for dict in data:
		trait_editor.traits.append(CharacterTraitMod.load_from_data(dict, lang))
	trait_editor.reload_traits_list()

#region Signal Callbacks
func _on_author_add():
	add_author()

func _on_author_del(id):
	author_lines.erase(id)
	if len(author_lines) == 1:
		author_lines[0].set_delete_enable(false)
	
func _on_mod_path_button_pressed():
	%FileDialog.popup_file_dialog()

func _on_file_dialog_dir_selected(dir):
	%FilePathDisplay.text = dir

func _on_file_dialog_file_selected(path):
	%FilePathDisplay.text = path.get_base_dir()

func _on_export_button_pressed():
	export()

func _on_import_button_pressed():
	import()

#endregion
