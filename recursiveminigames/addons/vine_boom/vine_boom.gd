@tool
extends EditorPlugin

var dock

func _enter_tree():
	# Load and instantiate the dock scene
	dock = preload("res://addons/vine_boom/vine_boom_dock.tscn").instantiate()
	
	# Add it to the bottom panel (with Output, Debugger, etc.)
	add_control_to_bottom_panel(dock, "Vine Boom")

func _exit_tree():
	# Clean up when disabling the plugin
	remove_control_from_bottom_panel(dock)
	if dock:
		dock.queue_free()
