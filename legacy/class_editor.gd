class_name ClassEditor
extends VBoxContainer

@export var classes: Array[CharacterClassMod] = []

var _current_class: CharacterClassMod = null

@onready var class_list = %ClassList
@onready var class_code_edit: LineEdit = %ClassCodeEdit
@onready var class_name_edit: LineEdit = %ClassNameEdit
@onready var class_desc_edit: TextEdit = %ClassDescEdit
@onready var class_enabled_check = %ClassEnabledCheck
@onready var trait_list = %TraitList
@onready var gear_list = %GearList


func _ready():
	reload_class_list()
	for item in Vanilla.CLOTHES:
		var button = Button.new()
		button.toggle_mode = true
		button.text = item
		gear_list.add_child(button)
		
		
func reload_class_list():
	if _current_class != null:
		_update_class(_current_class)
	class_list.clear()
	var root = class_list.create_item()
	for char_class in classes:
		var new = class_list.create_item(root)
		new.set_text(0, char_class.name)
		new.set_metadata(0, char_class)


func reload_trait_list(traits: Array[CharacterTraitMod]):
	for child in trait_list.get_children():
		child.queue_free()
	for char_trait in Vanilla.CHAR_TRAITS:
		trait_list.add_child(_make_toggle_button(char_trait))		
	for char_trait in traits:
		trait_list.add_child(_make_toggle_button(char_trait.code))


func _make_toggle_button(text: String, pressed: bool = false) -> Button:
	var rval = Button.new()
	rval.toggle_mode = true
	rval.text = text
	rval.button_pressed = pressed
	return rval		

func _load_class(char_class: CharacterClassMod):
	class_code_edit.text = char_class.code
	class_name_edit.text = char_class.name
	class_desc_edit.text = char_class.desc
	class_enabled_check.button_pressed = char_class.enabled
	for class_trait in trait_list.get_children():
		class_trait.button_pressed = class_trait.text in char_class.traits
	for class_gear in gear_list.get_children():
		class_gear.button_pressed = class_gear.text in char_class.gear


func _update_class(char_class: CharacterClassMod):
	char_class.code = class_code_edit.text
	char_class.name = class_name_edit.text
	char_class.desc = class_desc_edit.text
	char_class.enabled = class_enabled_check.button_pressed
	for class_trait in trait_list.get_children():
		if class_trait.button_pressed:
			print(class_trait.text)
			if not char_class.traits.has(class_trait.text):
				char_class.traits.append(class_trait.text)
		else:
			char_class.traits.erase(class_trait.text)
	for class_gear in gear_list.get_children():
		if class_gear.button_pressed:
			if not char_class.gear.has(class_gear.text):
				char_class.gear.append(class_gear.text)
		else:
			char_class.gear.erase(class_gear.text)


func _on_class_list_item_selected():
	var citem = class_list.get_selected()
	if citem == null:
		for class_trait in trait_list.get_children():
			class_trait.button_pressed = false
		for class_gear in gear_list.get_children():
			class_gear.button_pressed = false
		return
	var char_class = citem.get_metadata(0)
	if _current_class != null and char_class != _current_class:
		_update_class(_current_class)
	_load_class(char_class)		
	_current_class = char_class


func _on_add_class_button_pressed():
	var root = class_list.get_root()
	var new_class = CharacterClassMod.new()
	var new = class_list.create_item(root)
	new.set_text(0, new_class.name)
	new.set_metadata(0, new_class)
	classes.append(new_class)


func _on_del_class_button_pressed():
	if _current_class:
		class_list.get_selected().free()
		classes.erase(_current_class)
		_current_class = null


func _on_class_name_edit_text_changed(new_text):
	var citem = class_list.get_selected()
	if citem != null:
		citem.set_text(0, new_text)
