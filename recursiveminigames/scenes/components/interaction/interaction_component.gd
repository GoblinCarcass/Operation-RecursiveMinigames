class_name InteractionComponent extends Area3D

signal interaction_started


# Called externally by the player
func interact() -> void:
	interaction_started.emit()
	#print("I am interacting!")
