extends VBoxContainer
class_name TraitEditor

const ATTR_LINE_SCENE = preload("res://components/attribute_line.tscn")

@export var traits: Array[CharacterTraitMod] = []

var _current_trait: CharacterTraitMod = null

@onready var traits_list = %TraitsList
@onready var trait_code_edit = %TraitCodeEdit
@onready var trait_name_edit = %TraitNameEdit
@onready var positive_box = %PositiveBox
@onready var neutral_box = %NeutralBox
@onready var negative_box = %NegativeBox
@onready var trait_desc_edit = %TraitDescEdit
@onready var attr_list = %AttributeList


func _ready():
	reload_traits_list()
	for attr in Vanilla.CHAR_ATTRS:
		var new_line = ATTR_LINE_SCENE.instantiate()
		new_line.call_deferred("set_char_attr", attr)
		attr_list.add_child(new_line)


func reload_traits_list():
	traits_list.clear()
	var root = traits_list.create_item()
	for char_trait in traits:
		var new = traits_list.create_item(root)
		new.set_text(0, char_trait.name)
		new.set_metadata(0, char_trait)
	

#TODO
func get_trait_type() -> String:
	return "positive"


#TODO
func set_trait_type(value: String):
	pass


func _load_trait(char_trait: CharacterTraitMod):
	trait_code_edit.text = char_trait.code
	trait_name_edit.text = char_trait.name
	trait_desc_edit.text = char_trait.desc
	set_trait_type(char_trait.type)
	for attr in attr_list.get_children():
		var key = attr.get_char_attr()
		if char_trait.attributes.has(key):
			attr.set_activated(true)
			attr.set_value(char_trait.attributes[key])
		else:
			attr.set_activated(false)
			attr.set_value(0)


func _update_trait(char_trait: CharacterTraitMod):
	char_trait.code = trait_code_edit.text
	char_trait.name = trait_name_edit.text
	char_trait.desc = trait_desc_edit.text
	char_trait.type = get_trait_type()
	for attr in attr_list.get_children():
		if attr.is_activated():
			char_trait.attributes[attr.get_char_attr()] = attr.get_value()
		else:
			char_trait.attributes.erase(attr.get_char_attr())

		
func _on_traits_list_item_selected():
	var titem = traits_list.get_selected()
	print(titem)
	if titem == null:
		for attr_line in attr_list.get_children():
			attr_line.set_activated(false)
			attr_line.set_value(0)
		return
	var char_trait = titem.get_metadata(0)
	if _current_trait != null and char_trait != _current_trait:
		titem.set_text(0, trait_name_edit.text)
		_update_trait(_current_trait)
	_load_trait(char_trait)		
	_current_trait = char_trait


func _on_add_trait_button_pressed():
	var root = traits_list.get_root()
	var new_trait = CharacterTraitMod.new()
	var new = traits_list.create_item(root)
	new.set_text(0, new_trait.name)
	new.set_metadata(0, new_trait)
	traits.append(new_trait)
	

func _on_del_trait_button_pressed():
	if _current_trait:
		traits_list.get_selected().free()
		traits.erase(_current_trait)
		_current_trait = null
		
