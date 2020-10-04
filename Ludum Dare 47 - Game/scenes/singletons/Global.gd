extends Node

const MAX_HEALTH = 100
var health = 100

var darkness = 0.0

var ludum_dare = 0

func instantiate_node(packed_scene, pos = null):
	var clone = packed_scene.instance()
	var root = get_tree().root
	var parent = root.get_child(root.get_child_count()-1)
	parent.add_child(clone)
	
	if pos != null:
		clone.global_transform.origin = pos
	
	return clone
