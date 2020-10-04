extends Control

var player
var game_states

export(float) var speed = 0.01
export(bool) var disable = false

func _ready():
	player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")
	game_states = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("GameStates")
	
	$ColorRect.modulate.a = 0.0

func _process(delta):
	if disable == false:
		Global.darkness += delta * speed
		$ColorRect.modulate.a = Global.darkness
		
		if Global.darkness >= 1.0:
			nightmare()
			set_process(false)

func nightmare():
	yield(get_tree().create_timer(1.0), "timeout")
	player.health.decrease_health(1000)

func reset_darkness():
	Global.darkness = 0.0
	$ColorRect.modulate.a = Global.darkness
	set_process(true)
