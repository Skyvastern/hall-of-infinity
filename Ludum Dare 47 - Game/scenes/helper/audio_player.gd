extends AudioStreamPlayer

var is_music = false
var should_loop = false


func _ready():
	stop()


func play_sound(audio_stream):
	if audio_stream == null:
		AudioManager.created_audio.remove(AudioManager.created_audio.find(self))
		queue_free()
		return
	
	stream = audio_stream
	play(0.0)


func _on_AudioPlayer_finished():
	if should_loop:
		play(0.0)
	else:
		stop()
