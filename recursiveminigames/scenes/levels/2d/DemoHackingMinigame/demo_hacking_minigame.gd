extends Node2D

@onready var tile_map_layer: TileMapLayer = $Visuals/TileMap/TileMapLayer
var tile_set: TileSet = null
const PLAYER_HEX: PackedScene = preload(Paths.TEST_PLAYER_HEX)
const STARTING_TILE: Vector2i = Vector2i(2, 2)

var player: CharacterBody2D = PLAYER_HEX.instantiate()

func _ready() -> void:
	tile_set = tile_map_layer.get_tile_set()
	start_game()
	player.coords = STARTING_TILE
	print(str(tile_set.tile_size.x) + " " + str(tile_set.tile_size.y))


func start_game():
	# Load player into the starting tile on the map
	var starting_coords = tile_map_layer.map_to_local(STARTING_TILE)
	player.global_position.x = starting_coords.x
	player.global_position.y = starting_coords.y + (starting_coords.y / 2)
	self.add_child(player)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_type():
		if event is InputEventMouse:
			pass
