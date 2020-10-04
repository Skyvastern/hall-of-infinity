extends State

var only_once = false

func enter(delta):
	.enter(delta)
	
	get_tree().paused = true
	actor.pause_menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func update(delta):
	.update(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		phase = "EXIT"
		change_state("Playing")
		return


func exit(delta):
	.exit(delta)
	
	get_tree().paused = false
	actor.pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func resume_press():
	phase = "EXIT"
	change_state("Playing")

func exit_press():
	if only_once == false:
		only_once = true
		actor.fade.get_node("AnimationPlayer").play("Fade_In", -1.0, 2.0)
		
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().paused = false
		
		AudioManager.remove_all()
		get_tree().change_scene("res://scenes/ui/main_menu/main_menu.tscn")
