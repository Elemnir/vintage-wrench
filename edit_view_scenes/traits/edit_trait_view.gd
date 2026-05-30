class_name EditTraitView
extends EditViewBase

var _trait: CharacterTraitMod = CharacterTraitMod.new()

@onready var attribute_manager: AttributeManager = %AttributeManager
@onready var trait_code_edit: LineEdit = %TraitCodeEdit
@onready var trait_name_edit: LineEdit = %TraitNameEdit
@onready var trait_type_edit: OptionButton = %TraitTypeEdit
@onready var trait_desc_edit: TextEdit = %TraitDescEdit


func get_display_name() -> String:
	return _trait.name if _trait and _trait.name else "New Trait"


func get_loaded_object() -> ModObjectBase:
	_trait.code = trait_code_edit.text
	_trait.name = trait_name_edit.text
	_trait.desc = trait_desc_edit.text
	_trait.type = get_trait_type()
	_trait.attributes = attribute_manager.get_attribute_modifiers()
	return _trait


func load_using_object(obj: ModObjectBase):
	_trait = obj as CharacterTraitMod
	trait_code_edit.text = _trait.code
	trait_name_edit.text = _trait.name
	trait_desc_edit.text = _trait.desc
	set_trait_type(_trait.type)
	attribute_manager.set_attribute_modifiers(_trait.attributes)
	code_changed.emit(_trait.code)
	name_changed.emit(_trait.name)


func get_trait_type() -> String:
	return trait_type_edit.get_item_text(trait_type_edit.selected).to_lower()


func set_trait_type(value: String):
	for idx in range(trait_type_edit.item_count):
		if value == trait_type_edit.get_item_text(idx).to_lower():
			trait_type_edit.select(idx)



func _on_trait_code_edit_text_changed(new_text: String) -> void:
	code_changed.emit(new_text)


func _on_trait_name_edit_text_changed(new_text: String) -> void:
	name_changed.emit(new_text)
