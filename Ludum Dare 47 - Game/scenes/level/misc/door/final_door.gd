extends Area

onready var game_states = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("GameStates")
var only_once = false

func _on_Area_body_entered(body):
	if body.get_name() == "Player":
		if only_once == false:
			only_once = true
			game_states.current_state = game_states.states["ControlsOFF"]
