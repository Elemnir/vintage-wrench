class_name ModInfo
extends ModObjectBase

@export var name: String
@export var desc: String
@export var version: String
@export var authors: Array[String]

func get_data_entry() -> Dictionary[String,Variant]:
	return {
		"modid": code,
		"name": name,
		"description": desc,
		"version": version,
		"authors": authors
	}
	

func get_lang_entry() -> Dictionary[String,String]:
	return {}


static func load_from_data(data: Dictionary[String,Variant]) -> ModInfo:
	var rval = ModInfo.new()
	rval.code = data["modid"]
	rval.name = data["name"]
	rval.desc = data["description"]
	rval.version = data["version"]
	rval.authors = data["authors"]
	return rval
