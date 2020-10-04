extends Control

var remaining_time = 3.0
var time_label

func _ready():
	time_label = $TimeBackground/TimeLabel
	time_label.text = "Reloading in -\n" + str(stepify(remaining_time, 0.01))
	set_process(false)

func _process(delta):
	remaining_time -= delta
	remaining_time = max(0, remaining_time)
	time_label.text = "Reloading in -\n" + str(stepify(remaining_time, 0.01))
	
	if remaining_time == 0.0:
		set_process(false)

func reset_remaining_time():
	remaining_time = 3.0
