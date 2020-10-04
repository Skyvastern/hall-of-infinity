extends Spatial

var checkpoints = []
var current_checkpoint = null

func _ready():
	for point in get_children():
		checkpoints.append(point)
	
	if checkpoints.size() > 0:
		current_checkpoint = checkpoints[0]
