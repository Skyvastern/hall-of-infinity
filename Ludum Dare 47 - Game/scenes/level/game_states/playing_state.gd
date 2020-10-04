extends State


func update(delta):
	.update(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		phase = "EXIT"
		change_state("Paused")
		return
