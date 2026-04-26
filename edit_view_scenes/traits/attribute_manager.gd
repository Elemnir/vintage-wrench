class_name AttributeManager
extends VSplitContainer

const ATTR_SCENE = preload("res://components/attribute_line.tscn")

var _active_attributes: Dictionary[Button, AttributeLine]

@onready var available_attributes: VBoxContainer = %AvailableAttributes
@onready var selected_attributes: VBoxContainer = %SelectedAttributes


func _ready() -> void:
	make_attributes_available(Vanilla.CHAR_ATTRS)


func get_attribute_modifiers() -> Dictionary[String, float]:
	var rval: Dictionary[String, float] = {}
	for attr in _active_attributes.values():
		rval[attr.attribute] = attr.value
	return rval


func make_toggle_button(text: String) -> Button:
	var rval = Button.new()
	rval.text = text
	rval.toggle_mode = true
	rval.toggled.connect(_on_attribute_toggled.bind(rval))
	return rval


func make_attributes_available(attr_list: Array[String]):
	for attr in attr_list:
		available_attributes.add_child(make_toggle_button(attr))


func set_attribute_modifiers(attrs: Dictionary[String, float]):
	for attr_btn in available_attributes.get_children():
		if attrs.has(attr_btn.text):
			_set_attribute_active(attr_btn, attrs[attr_btn.text])
			attr_btn.set_pressed_no_signal(true)


func _set_attribute_active(btn: Button, value: float = 0.0):
	var attr_mod = ATTR_SCENE.instantiate()
	attr_mod.attribute = btn.text
	attr_mod.value = value
	attr_mod.removal_queued.connect(_on_attribute_removed.bind(attr_mod))
	_active_attributes[btn] = attr_mod
	selected_attributes.add_child(attr_mod)


func _on_attribute_toggled(toggled_on: bool, btn: Button):
	if toggled_on:
		_set_attribute_active(btn)
	else:
		_active_attributes[btn].queue_free()
		_active_attributes.erase(btn)


func _on_attribute_removed(attr: AttributeLine):
	var btn = _active_attributes.find_key(attr)
	if btn:
		btn.set_pressed_no_signal(false)
		_active_attributes.erase(btn)
