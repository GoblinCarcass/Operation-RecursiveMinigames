extends Node

# Game Manager
@warning_ignore("unused_signal")
signal scene_3d_changed
@warning_ignore("unused_signal")
signal scene_2d_changed
@warning_ignore("unused_signal")
signal scene_gui_changed

# Dialog 
@warning_ignore("unused_signal")
signal dialog_started(id: String)
@warning_ignore("unused_signal")
signal dialog_acknowledged
@warning_ignore("unused_signal")
signal dialog_box_visibility_set(is_visible: bool)


# Player
# TODO: Figure out if I can set the movement mode outside of the SignalBus
@warning_ignore("unused_signal")
signal player_movement_mode_set(can_move: bool)
@warning_ignore("unused_signal")
signal player_can_rotate_camera_mode_set(can_rotate: bool)

# UI
@warning_ignore("unused_signal")
signal crosshair_text_changed(text: String)
@warning_ignore("unused_signal")
signal crosshair_changed(crosshair: Texture2D)
@warning_ignore("unused_signal")
signal crosshair_visibility_changed(is_visible: bool)
