extends State

func enter(delta):
	.enter(delta)
	
	actor.game_won_ui.visible = true
	actor.game_won_ui.get_node("AnimationPlayer").play("Fade_In")
	actor.player.is_out_of_control = true
	
	yield(get_tree().create_timer(7.0), "timeout")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://scenes/ui/main_menu/main_menu.tscn")
