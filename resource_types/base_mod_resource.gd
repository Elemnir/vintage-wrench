@abstract class_name BaseModResource
extends Resource

const FQN_FMT: String = "game:%s-%s"

@export var code: String = ""

func get_data_entry() -> Dictionary[String,Variant]:
	return {}

func get_lang_entry() -> Dictionary[String,String]:
	return {}
