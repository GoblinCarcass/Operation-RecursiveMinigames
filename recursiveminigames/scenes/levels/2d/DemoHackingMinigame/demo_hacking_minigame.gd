extends Node2D

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
const HEX_PLAYER = preload(Paths.TEST_PLAYER_HEX)
var player = null

func _ready() -> void:
	player = HEX_PLAYER.instantiate()
	if not player == null:
		spawner_component.spawn(player, "player_start")
