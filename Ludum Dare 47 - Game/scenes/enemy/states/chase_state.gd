extends State

func enter(delta):
	.enter(delta)
	
	actor.speed = 15
	actor.animation.play("Run", 0.1)


func update(delta):
	.update(delta)
	
	# Rotates around y-axis to look at player
	actor.look_at_target(actor.get_player_pos())
	
	# Sets direction towards player
	actor.dir = (actor.get_player_pos() - actor.global_transform.origin).normalized()
	
	# Switch to attack when player too close
	if actor.get_distance_to_player() <= actor.ATTACK_DISTANCE:
		phase = "EXIT"
		change_state("Attack")
		return
	
	# Switch to idle when player too far
	if actor.get_distance_to_player() > actor.CHASE_DISTANCE:
		phase = "EXIT"
		change_state("Idle")
		return
	
	# If player is knocked down
	if actor.player.knocked_down == true:
		phase = "EXIT"
		change_state("Idle")
		return
