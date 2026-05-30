class_name ModInfo
extends ModObjectBase


@export var name: String
@export var desc: String
@export var version: String
@export var authors: Array


func get_data_entry() -> Dictionary[String,Variant]:
	return {
		"modid": code,
		"name": name,
		"description": desc,
		"type": "content",
		"version": version,
		"authors": authors
	}


func get_lang_entry() -> Dictionary[String,String]:
	return {}


static func get_edit_scene() -> PackedScene:
	return preload("res://edit_view_scenes/mod_info/edit_mod_info.tscn")


static func get_file_path() -> String:
	return "/modinfo.json"


static func load_from_data(data: Dictionary) -> ModInfo:
	var rval = ModInfo.new()
	rval.code = data["modid"]
	rval.name = data["name"]
	rval.desc = data["description"]
	rval.version = data["version"]
	rval.authors = data["authors"]
	return rval
