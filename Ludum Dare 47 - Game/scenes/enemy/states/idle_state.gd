extends State

func enter(delta):
	.enter(delta)
	
	actor.speed = 0
	actor.animation.play("Idle", 0.1)
	actor.get_node("IdleTimer").start()


func update(delta):
	.update(delta)
	
	# Set of conditions when player gets detected
	if actor.detected:
		
		# If enemy set to stationary type
		if actor.stationary:
			if actor.get_distance_to_player() <= actor.STATIONARY_ATTACK_DISTANCE:
				phase = "EXIT"
				change_state("Attack")
				return
		
		# If enemy set to normal/chasing type
		else:
			if actor.get_distance_to_player() <= actor.CHASE_DISTANCE:
				phase = "EXIT"
				change_state("Chase")
				return




func _on_IdleTimer_timeout():
	phase = "EXIT"
	change_state("Patrol")
	
	if actor.detected:
		actor.detected = false
