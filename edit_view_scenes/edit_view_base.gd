@abstract class_name EditViewBase
extends MarginContainer

@warning_ignore("unused_signal") signal code_changed(new_code: String)
@warning_ignore("unused_signal") signal name_changed(new_name: String)

@abstract func get_display_name() -> String
@abstract func get_loaded_object() -> ModObjectBase
@abstract func load_using_object(obj: ModObjectBase)
