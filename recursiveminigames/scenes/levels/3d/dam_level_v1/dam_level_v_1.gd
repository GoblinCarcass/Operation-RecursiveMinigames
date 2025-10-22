extends Node3D

const PLAYER_3D = preload(Paths.TEST_PLAYER_3D)

@onready var spawner_component: SpawnerComponent = $SpawnerComponent

func _ready() -> void:
	
	spawner_component.spawn(PLAYER_3D.instantiate(), "default-spawn")
