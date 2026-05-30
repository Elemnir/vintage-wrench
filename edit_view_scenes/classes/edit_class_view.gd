class_name EditClassView
extends EditViewBase

var _class: CharacterClassMod = CharacterClassMod.new()

@onready var class_code_edit = %ClassCodeEdit
@onready var class_name_edit = %ClassNameEdit
@onready var class_enabled_check = %ClassEnabledCheck
@onready var class_desc_edit = %ClassDescEdit
@onready var gear_manager = %GearManager
@onready var trait_manager = %TraitManager

func _ready() -> void:
	gear_manager.make_options_available(Vanilla.CLOTHES)
	trait_manager.make_options_available(Vanilla.CHAR_TRAITS)

func get_display_name() -> String:
	return _class.name if _class and _class.name else "New Class"

func get_loaded_object() -> ModObjectBase:
	_class.code = class_code_edit.text
	_class.name = class_name_edit.text
	_class.enabled = class_enabled_check.is_pressed()
	_class.desc = class_desc_edit.text
	_class.gear = gear_manager.get_selected_options()
	_class.traits = trait_manager.get_selected_options()
	return _class

func load_using_object(obj: ModObjectBase):
	_class = obj as CharacterClassMod
	class_code_edit.text = _class.code
	class_name_edit.text = _class.name
	class_enabled_check.set_pressed(_class.enabled)
	class_desc_edit.text = _class.desc
	gear_manager.load_selected_options(_class.gear)
	trait_manager.load_selected_options(_class.traits)
	code_changed.emit(_class.code)
	name_changed.emit(_class.name)
