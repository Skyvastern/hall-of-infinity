extends Spatial

var ambients = [
	"Ambient01",
	"Ambient02",
	"Ambient03"
]

func _ready():
	yield(get_tree().create_timer(2.0), "timeout")
	play_next_audio()


func _on_Timer_timeout():
	yield(get_tree().create_timer(2.0), "timeout")
	play_next_audio()


func play_next_audio():
	randomize()
	var index = randi()%3
	AudioManager.play_sound(ambients[index], false, -2.0)
	$Timer.start()
