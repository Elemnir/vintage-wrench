extends HFlowContainer
class_name AttributeLine

signal removal_queued

@onready var attribute: String:
	get():
		return _label.text
	set(x):
		set_attribute.call_deferred(x)
		
@onready var value: float:
	get():
		return _spin_box.value 
	set(x):
		set_value.call_deferred(x)

@onready var _spin_box: SpinBox = $SpinBox
@onready var _label: Label = $Label

func set_attribute(text: String):
	_label.text = text

func set_value(val: float):
	_spin_box.value = val

func _on_button_pressed() -> void:
	queue_free()
	removal_queued.emit()
