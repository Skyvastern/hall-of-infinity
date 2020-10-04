extends Spatial

var states = {}
var current_state = null

var player = null
var checkpoint_manager = null
var darkness = null

var pause_menu = null
var game_over_ui = null
var game_won_ui = null
var fade = null

func _ready():
	states = {
		"PrePlaying" : $Preplaying,
		"Playing" : $Playing,
		"Paused" : $Paused,
		"GameOver" : $GameOver,
		"ControlsOFF" : $ControlsOFF
	}
	
	current_state = states["PrePlaying"]
	
	player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")
	checkpoint_manager = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("CheckpointManager")
	darkness = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Darkness")
	
	fade = $UI/Fade
	pause_menu = $UI/PauseMenu
	pause_menu.visible = false
	game_over_ui = $UI/GameOverUI
	game_over_ui.visible = false
	game_won_ui = $UI/GameWon
	game_won_ui.visible = false


func _process(delta):
	current_state = current_state.process_states(delta)


# For outside classes, unrelated to game_states and it's states
func fade_in():
	fade.get_node("AnimationPlayer").play("Fade_In", -1.0, 2.0)

func fade_out():
	fade.get_node("AnimationPlayer").play("Fade_Out", -1.0, 0.1)
