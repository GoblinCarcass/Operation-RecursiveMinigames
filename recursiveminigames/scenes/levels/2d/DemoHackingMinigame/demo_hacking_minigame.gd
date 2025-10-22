extends Node2D

@onready var tile_map_layer: TileMapLayer = %TileMapLayer
@onready var entities: TileMapLayer = %EntityLayer

var debug_mode: bool = false
var tile_set: TileSet = null
var _current_cell: Vector2i = Vector2i.ZERO
func _ready() -> void:
	pass
	#tile_set = tile_map_layer.get_tile_set()
	#print(str(tile_set.tile_size.x) + "px , " + str(tile_set.tile_size.y) + "px") # Print size of a single cell in the TileSet in px
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
	if event is InputEventMouseMotion:
		var cell: Vector2i = tile_map_layer.local_to_map(get_global_mouse_position())
		if debug_mode == true:
			debug_print_cell(cell)


func debug_print_cell(cell: Vector2i):
	if cell != _current_cell:
		print(cell)
	_current_cell = cell
