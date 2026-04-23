class_name CharacterClassMod
extends ModObjectBase

const NAMEKEY = "characterclass"
const DESCKEY = "characterdesc"

@export var enabled: bool = true
@export var name = "MyClass"
@export var desc = "<font color=\"#99c9f9\"><i>This is the class description. \
	Add some cool quote here.</i></font><br><br>You can use any VTML tag in here."

var traits: Array = []
var gear: Array = []

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

func _render_gear() -> Array:
	var rval = []
	for item in gear:
		rval.append({
			"type": "item",
			"code": item,
		})
	return rval
	
static func load_from_data(data: Dictionary, lang: Dictionary) -> CharacterClassMod:
	var rval = CharacterClassMod.new()
	rval.enabled = data["enabled"]
	rval.code = data["code"]
	rval.traits = data["traits"]
	rval.gear = data["gear"].map(func (x): return x["code"])
	rval.name = lang[FQN_FMT % [NAMEKEY, rval.code]]
	rval.desc = lang[FQN_FMT % [DESCKEY, rval.code]]
	return rval
