class_name DialogManager extends Control

func _ready() -> void:
	self.visible = false
	SignalBus.dialog_box_visibility_set.connect(_on_dialog_visibility_set)


func _on_dialog_visibility_set(mode: bool):
	self.visible = mode


func _on_tree_exited() -> void:
	if SignalBus.dialog_box_visibility_set.is_connected(_on_dialog_visibility_set):
		SignalBus.dialog_box_visibility_set.disconnect(_on_dialog_visibility_set)
