class_name EditClassView
extends EditViewBase

var _class: CharacterClassMod = CharacterClassMod.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func get_display_name() -> String:
	return _class.name if _class and _class.name else "New Class"

func get_loaded_object() -> ModObjectBase:
	return _class

func load_using_object(obj: ModObjectBase):
	_class = obj
