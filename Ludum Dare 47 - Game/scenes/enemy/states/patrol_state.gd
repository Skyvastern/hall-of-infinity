extends State

var index = -1

func enter(delta):
	.enter(delta)
	
	actor.speed = 5
	actor.animation.play("Walk", 0.1)
	
	next_waypoint()

func update(delta):
	.update(delta)
	
	# If no waypoints, return
	if actor.waypoints == null or actor.waypoints.size() < 2:
		print("No waypoints set, there needs to be atleast 2")
		return
	
	# Set of conditions when player detected
	if actor.detected == true:
		
		# If enemy set to stationary type
		if actor.stationary == true:
			if actor.get_distance_to_player() <= actor.STATIONARY_ATTACK_DISTANCE:
				phase = "EXIT"
				change_state("Attack")
				return
			else:
				phase = "EXIT"
				change_state("Idle")
				return
		
		# If enemy set to normal/chasing type
		else:
			if actor.get_distance_to_player() <= actor.ATTACK_DISTANCE:
				phase = "EXIT"
				change_state("Attack")
				return
			elif actor.get_distance_to_player() <= actor.CHASE_DISTANCE:
				phase = "EXIT"
				change_state("Chase")
				return
			else:
				phase = "EXIT"
				change_state("Idle")
				return
	
	# Looks at waypoint, rotates around y-axis
	actor.look_at_target(actor.waypoints[index])
	
	# Switches to idle when reaches its destination
	if actor.global_transform.origin.distance_to(actor.waypoints[index]) < 2.0:
		phase = "EXIT"
		change_state("Idle")
		return

func exit(delta):
	.exit(delta)


# Sets next waypoint and updates direction
func next_waypoint():
	index += 1
	if index >= actor.waypoints.size():
		index = 0
	
	actor.dir = (actor.waypoints[index] - actor.global_transform.origin).normalized()
