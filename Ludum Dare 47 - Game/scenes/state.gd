extends Spatial
class_name State

var state = null
var phase = "ENTER"

var actor = null

func _ready():
	actor = owner

func process_states(delta):
	if phase == "ENTER":
		enter(delta)
	if phase == "UPDATE":
		update(delta)
	if phase == "EXIT":
		exit(delta)
	
	return state


func enter(_delta):
	state = self
	phase = "UPDATE"

func update(_delta):
	phase = "UPDATE"

func exit(_delta):
	phase = "ENTER"

func change_state(new_state):
	state = actor.states[new_state]
