extends Node

# Game Manager


# Dialogue 
signal dialogue_started(id: String)
signal dialogue_acknowledged

signal dialogue_box_visibility_set(is_visible: bool)

# TODO: Figure out if I can set the movement mode outside of the SignalBus
# Player
signal player_movement_mode_set(can_move: bool)

# UI
signal crosshair_text_changed(text: String)
signal crosshair_changed(crosshair: Texture2D)
signal crosshair_visibility_changed(is_visible: bool)
