class_name EditModInfo
extends EditViewBase

const AUTHOR_SCENE = preload("res://components/author_line.tscn")

var _info: ModInfo = ModInfo.new()

@onready var author_section = %AuthorSection
@onready var author_lines: Array[AuthorLine] = []

func _ready():
	pass


func get_author_data() -> Array[String]:
	var rval: Array[String] = []
	for line in author_lines:
		rval.append(line.get_author_name())
	return rval


func get_display_name() -> String:
	return "Mod Info"


func get_loaded_object():
	_info.code = %DomainNameInput.text
	_info.version = %VersionInput.text
	_info.name = %PrettyNameInput.text
	_info.desc = %DescriptionInput.text
	_info.authors = get_author_data()
	return _info


func load_using_object(obj: ModObjectBase):
	_info = obj as ModInfo
	%DomainNameInput.text = _info.code
	%VersionInput.text = _info.version
	%PrettyNameInput.text = _info.name
	%DescriptionInput.text = _info.desc
	for author in _info.authors:
		var new = add_author()
		new.set_author_name(author)


func add_author() -> AuthorLine:
	var new_line = AUTHOR_SCENE.instantiate()
	new_line.add_pressed.connect(_on_author_add)
	new_line.del_pressed.connect(_on_author_del)
	author_lines.append(new_line)
	if len(author_lines) > 1:
		for line in author_lines:
			line.call_deferred("set_delete_enable", true)
	author_section.add_child(new_line)
	return new_line


func _on_author_add():
	add_author()


func _on_author_del(id):
	author_lines.erase(id)
	if len(author_lines) == 1:
		author_lines[0].set_delete_enable(false)
