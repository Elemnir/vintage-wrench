extends HFlowContainer
class_name AuthorLine

signal add_pressed
signal del_pressed(id)

@onready var del_button = $DelButton

func get_author_name() -> String:
	return $NameInput.text

func set_delete_enable(enabled:bool = true):
	del_button.disabled = not enabled

func _on_add_button_pressed():
	add_pressed.emit()

func _on_del_button_pressed():
	del_pressed.emit(self)
	queue_free()
