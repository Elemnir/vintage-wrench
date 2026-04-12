class_name CharacterClassMod
extends BaseModResource

const NAMEKEY = "characterclass"
const DESCKEY = "characterdesc"

@export var enabled: bool = true
@export var name = "MyClass"
@export var desc = "<font color=\"#99c9f9\"><i>This is the class description. \
	Add some cool quote here.</i></font><br><br>You can use any VTML tag in here."

var traits: Array[String] = []
var gear: Array[String] = []

func get_data_entry() -> Dictionary[String,Variant]:
	return {
		"enabled": enabled,
		"code": code,
		"traits": traits,
		"gear": _render_gear(),
	}

func get_lang_entry() -> Dictionary[String,String]:
	return {
		FQN_FMT % [NAMEKEY, code]: name,
		FQN_FMT % [DESCKEY, code]: desc,
	}

func _render_gear() -> Array[Dictionary]:
	var rval = []
	for item in gear:
		rval.append({
			"type": "item",
			"code": item,
		})
	return rval
