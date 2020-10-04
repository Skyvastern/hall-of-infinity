extends Control

var only_once = false

func _ready():
	$Introduction.visible = false
	$Fade.visible = true
	$Fade/AnimationPlayer.play("Fade_Out", -1.0, 0.25)

func start_press():
	if only_once == false:
		only_once = true
		$Introduction.visible = true
		$Introduction/Introduction/AnimationPlayer.play("Fade_In")
		
		yield(get_tree().create_timer(0.2), "timeout")
		
		$Introduction/Introduction/AnimationPlayer.play("Type")
		
		yield(get_tree().create_timer(4.0), "timeout")
		
		$Fade/AnimationPlayer.play("Fade_In", -1.0, 2.0)
		get_tree().change_scene("res://scenes/level/level_A.tscn")

func exit_press():
	only_once = true
	$Fade/AnimationPlayer.play("Fade_In", -1.0, 2.0)
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()
