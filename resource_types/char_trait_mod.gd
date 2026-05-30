class_name CharacterTraitMod
extends ModObjectBase

const NAMEKEY = "traitname"
const DESCKEY = "trait"

@export var name = "MyTrait"
@export var desc = "<font color=\"#84ff84\">• My new trait </font>"
@export_enum("postive", "negative", "neutral") var type: String = "positive"

var attributes: Dictionary = {}


func get_data_entry() -> Dictionary[String,Variant]:
	return {
		"code": code,
		"type": type,
		"attributes": attributes,
	}


func get_lang_entry() -> Dictionary[String,String]:
	return {
		FQN_FMT % [NAMEKEY, code]: name,
		FQN_FMT % [DESCKEY, code]: desc,
	}


static func get_edit_scene() -> PackedScene:
	return preload("res://edit_view_scenes/traits/edit_trait_view.tscn")


static func get_file_path() -> String:
	return "/config/traits.json"


static func load_from_data(data: Dictionary, lang: Dictionary) -> CharacterTraitMod:
	var rval = CharacterTraitMod.new()
	rval.code = data["code"]
	rval.type = data["type"]
	rval.attributes = data["attributes"]
	rval.name = lang[FQN_FMT % [NAMEKEY, rval.code]]
	rval.desc = lang[FQN_FMT % [DESCKEY, rval.code]]
	return rval
