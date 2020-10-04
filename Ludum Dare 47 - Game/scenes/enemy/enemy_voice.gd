extends Spatial

var voices = [
	"EnemyVoice01",
	"EnemyVoice02"
]

func _ready():
	yield(get_tree().create_timer(2.0), "timeout")
	play_next_audio()


func _on_Timer_timeout():
	yield(get_tree().create_timer(2.0), "timeout")
	play_next_audio()


func play_next_audio():
	randomize()
	var index = randi()%2
	AudioManager.play_sound(voices[index], false, -2.0)
	$Timer.start()
