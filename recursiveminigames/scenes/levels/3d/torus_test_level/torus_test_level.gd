extends Node3D

#TODO: Player scene shouldn't be loaded inside of a level, rethink where you should dump it.
const PLAYER = preload(Paths.TEST_PLAYER_3D)

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

func _ready() -> void:
	spawner_component.spawn_entity(PLAYER.instantiate(), "Default")
