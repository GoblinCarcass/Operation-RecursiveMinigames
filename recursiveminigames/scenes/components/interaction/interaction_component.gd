class_name InteractionComponent extends Area3D

signal interaction_started


func _ready() -> void:
	pass
	#print("Hello from Interaction Component!")


func interact() -> void:
	print("I am interacting!")
	interaction_started.emit()
