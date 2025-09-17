class_name GraphManager2D extends Node2D

# Dictionary typing sucks some serious DICK
# Fuck me, man
var graph_connections: Dictionary[GraphNode2D, Array]

func _ready() -> void:
	var graph_nodes: Array[Node]  = get_children()
	for node in graph_nodes:
		if node is not GraphNode2D:
			printerr("The " + node.name + " Node inside of the " + name + " GraphManager is of incorrect type")
			continue
		graph_connections[node as GraphNode2D] = node.get_connections()
