extends Node

# Dialogue 
signal dialogue_started(id: String)
signal dialogue_acknowledged

# TODO: Figure out if it can be done in a better way
# Player
signal player_movement_mode_set(can_move: bool)
