extends Node

# Game Manager
signal scene_3d_changed
signal scene_2d_changed
signal scene_gui_changed

# Dialog 
signal dialog_started(id: String)
signal dialog_acknowledged
signal dialog_box_visibility_set(is_visible: bool)


# Player
# TODO: Figure out if I can set the movement mode outside of the SignalBus
signal player_movement_mode_set(can_move: bool)
signal player_can_rotate_camera_mode_set(can_rotate: bool)

# UI
signal crosshair_text_changed(text: String)
signal crosshair_changed(crosshair: Texture2D)
signal crosshair_visibility_changed(is_visible: bool)
