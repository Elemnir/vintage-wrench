extends TabContainer

const AUTHOR_SCENE = preload("res://components/author_line.tscn")
const MODINFO_NAME = "modinfo.json"

@onready var author_section = %AuthorSection
@onready var author_lines: Array[AuthorLine] = [%DefaultAuthorLine]
@onready var file_path_disp = %FilePathDisplay


func _ready():
	%DefaultAuthorLine.add_pressed.connect(_on_author_add)
	%DefaultAuthorLine.del_pressed.connect(_on_author_del)
	

func export():
	var domain = $%DomainNameInput.text
	var path = "assets/%s/config" % domain
	var wd = DirAccess.open(file_path_disp.text)
	FileAccess.open(
		wd.get_current_dir() + '/' + MODINFO_NAME, FileAccess.WRITE
	).store_string(get_mod_info_json())
	if not wd.dir_exists(path):
		wd.make_dir_recursive(path)
	FileAccess.open(
		wd.get_current_dir() + '/' + path + "/characterclasses.json", FileAccess.WRITE
	).store_string(get_char_classes_json())
	FileAccess.open(
		wd.get_current_dir() + '/' + path + "/traits.json", FileAccess.WRITE
	).store_string(get_char_traits_json())

func import():
	pass


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


func get_char_classes_json() -> String:
	var char_classes = []
	return JSON.stringify(char_classes)


func get_char_traits_json() -> String:
	var char_traits = []
	return JSON.stringify(char_traits)


#region Signal Callbacks
func _on_author_add():
	var new_line = AUTHOR_SCENE.instantiate()
	new_line.add_pressed.connect(_on_author_add)
	new_line.del_pressed.connect(_on_author_del)
	author_lines.append(new_line)
	for line in author_lines:
		line.call_deferred("set_delete_enable", true)
	author_section.add_child(new_line)

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
