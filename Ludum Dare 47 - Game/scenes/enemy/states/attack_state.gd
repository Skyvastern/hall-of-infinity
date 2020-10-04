extends State

func enter(delta):
	.enter(delta)
	
	actor.speed = 0
	actor.animation.play("Shoot", 0.1)


func update(delta):
	.update(delta)
	
	actor.look_at_target(actor.player.global_transform.origin)
	actor.chest_look()
	
	if actor.stationary:
		if actor.get_distance_to_player() > actor.STATIONARY_ATTACK_DISTANCE:
			phase = "EXIT"
			change_state("Patrol")
			return
	
	elif actor.get_distance_to_player() > actor.ATTACK_DISTANCE:
		phase = "EXIT"
		change_state("Chase")
		return
	
	if actor.player.knocked_down:
		phase = "EXIT"
		change_state("Idle")
		return
