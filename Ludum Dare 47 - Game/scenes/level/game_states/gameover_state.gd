extends State


func enter(delta):
	.enter(delta)
	
	if actor.player.knocked_down == true:
		actor.game_over_ui.visible = true
		actor.game_over_ui.reset_remaining_time()
		actor.game_over_ui.set_process(true)
		yield(get_tree().create_timer(3.0), "timeout")
	
	actor.darkness.reset_darkness()
	actor.fade.get_node("AnimationPlayer").play("Fade_In", -1.0, 2.0)
	$TransitonTimer.start()


func exit(delta):
	.exit(delta)
	
	if actor.player.knocked_down == true:
		actor.game_over_ui.visible = false
		actor.game_over_ui.set_process(false)
		actor.player.reincarnate()



func _on_TransitonTimer_timeout():
	var starting_pos = actor.checkpoint_manager.current_checkpoint.global_transform.origin
	actor.player.global_transform.origin = starting_pos
	
	phase = "EXIT"
	change_state("PrePlaying")
