class_name GraphManager2D extends Node2D

var indexed_graph_nodes: Dictionary[int, GraphNode2D]
var graph_connections: Dictionary[int, Array]

func _ready() -> void:
	# Initial index of the graph nodes
	var node_array: Array[Node] = get_children()
	for node in node_array:
		if node is not GraphNode2D:
			printerr("The " + node.name + " Node inside of the " + name + " GraphManager is of incorrect type at the " + self.get_parent().name + " level")
			continue
		indexed_graph_nodes[node.get_index()] = node
	
	# Save the connections between the nodes
	# TODO: Properly save the connections between nodes
	for key in indexed_graph_nodes.keys():
		var node: GraphNode2D = indexed_graph_nodes[key]
		graph_connections[key] = node.connections
	
	print("Nodes: " + str(indexed_graph_nodes))
	print("Connections: " + str(graph_connections))
