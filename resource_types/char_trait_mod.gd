class_name CharacterTraitMod
extends BaseModResource

const NAMEKEY = "traitname"
const DESCKEY = "trait"

@export var name = "MyTrait"
@export var desc = "<font color=\"#84ff84\">• My new trait </font>"
@export_enum("postive", "negative", "neutral") var type: String = "positive"

var attributes: Dictionary[String, float] = {}

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
