@abstract class_name ModObjectBase
extends Resource

const FQN_FMT: String = "game:%s-%s"

static var edit_scene: PackedScene
static var file_path: String

@export var code: String = ""

@abstract func get_data_entry() -> Dictionary[String,Variant]
@abstract func get_lang_entry() -> Dictionary[String,String]

static func get_default_code() -> String:
	return "invalid-code"

static func get_default_name() -> String:
	return "New Entry"

static func get_edit_scene() -> PackedScene:
	return edit_scene

static func get_file_path() -> String:
	return file_path
