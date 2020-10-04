extends State


func enter(delta):
	.enter(delta)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	actor.fade.get_node("AnimationPlayer").play("Fade_Out", -1.0, 0.1)
	
	phase = "EXIT"
	change_state("Playing")
