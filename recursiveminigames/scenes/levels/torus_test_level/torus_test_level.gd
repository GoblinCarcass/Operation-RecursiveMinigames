extends Node3D

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

const PLAYER = preload(Paths.TEST_PLAYER_3D)

func _ready() -> void:
	var player_node = PLAYER.instantiate()
	spawner_component.spawn_entity(player_node, "Default")
