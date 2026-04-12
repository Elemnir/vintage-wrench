extends HFlowContainer
class_name AttributeLine

@onready var spin_box = $SpinBox
@onready var spacer = $Spacer
@onready var button = $Button

func is_activated() -> bool:
	return button.button_pressed

func get_char_attr() -> String:
	return button.text
	
func get_value() -> float:
	return spin_box.value

func set_activated(is_active: bool):
	button.set_pressed(is_active)
	
func set_char_attr(new: String):
	button.text = new

func set_value(value: float):
	spin_box.value = value

func _on_button_toggled(toggled_on: bool):
	spin_box.visible = toggled_on
	spacer.visible = not toggled_on
