@abstract class_name ModObjectBase
extends Resource

const FQN_FMT: String = "game:%s-%s"

@export var code: String = ""

@abstract func get_data_entry() -> Dictionary[String,Variant]

@abstract func get_lang_entry() -> Dictionary[String,String]
