class_name GearManager
extends VSplitContainer

const ADD_BUTTON_TEXTURE: Texture2D = preload("res://assets/icons/Add.svg")
const DEL_BUTTON_TEXTURE: Texture2D = preload("res://assets/icons/Remove.svg")

# Pointers to the Tree roots for simplicity
var _equipped: TreeItem
var _available: TreeItem

@onready var available_gear = %AvailableGear
@onready var equipped_gear = %EquippedGear


func _ready():
	_available = available_gear.create_item()
	_equipped = equipped_gear.create_item()
	make_gear_available(Vanilla.CLOTHES)


static func find_or_create_category(parent: TreeItem, gear_code: String) -> TreeItem:
	for part in gear_code.split('-', false).slice(0,-1):
		parent = find_or_create_child_with_text(parent, part)
		parent.set_selectable(0, false)
		parent.set_collapsed(true)
	return parent


static func find_or_create_child_with_text(parent: TreeItem, text: String, column: int = 0) -> TreeItem:
	for child in parent.get_children():
		if child.get_text(column) == text:
			return child
	var rval = parent.create_child()
	rval.set_text(column, text)
	return rval


func load_equipped_gear(gear_codes: Array[String]):
	for item in gear_codes:
		var parent = find_or_create_category(_available, item)
		set_gear_equipped(find_or_create_child_with_text(parent, item))


func make_gear_available(gear_codes: Array[String]):
	for item in gear_codes:
		var parent = find_or_create_category(_available, item)
		var new_item = find_or_create_child_with_text(parent, item)
		new_item.add_button(0, ADD_BUTTON_TEXTURE)


func set_gear_equipped(avail_item: TreeItem):
	var equip_item = find_or_create_child_with_text(_equipped, avail_item.get_text(0))
	if equip_item.get_button_count(0) == 0:
		equip_item.add_button(0, DEL_BUTTON_TEXTURE)
	avail_item.set_button_disabled(0, 0, true)
	avail_item.set_selectable(0, false)
	
	
func set_gear_unequipped(equip_item: TreeItem):
	var gear_code = equip_item.get_text(0)
	var avail_item = find_or_create_child_with_text(
		find_or_create_category(_available, gear_code), gear_code
	)
	avail_item.set_selectable(0, true)
	avail_item.set_button_disabled(0, 0, false)
	equip_item.free()


func _on_available_gear_button_clicked(item, _column, _id, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		set_gear_equipped(item)

func _on_available_gear_item_activated():
	set_gear_equipped(available_gear.get_selected())
	
func _on_equipped_gear_button_clicked(item, _column, _id, mouse_button_index):
	if mouse_button_index == MOUSE_BUTTON_LEFT:
		set_gear_unequipped(item)

func _on_equipped_gear_item_activated():
	set_gear_unequipped(equipped_gear.get_selected())
