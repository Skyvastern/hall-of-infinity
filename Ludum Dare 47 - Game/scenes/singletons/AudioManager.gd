extends Node

var audio_clips = {
	"Ambient01" : preload("res://assets/audio/Ambient01.wav"),
	"Ambient02" : preload("res://assets/audio/Ambient02.wav"),
	"Ambient03" : preload("res://assets/audio/Ambient03.wav"),
	"EnemyVoice01" : preload("res://assets/audio/EnemyVoice01.wav"),
	"EnemyVoice02" : preload("res://assets/audio/EnemyVoice02.wav"),
	"Jump" : preload("res://assets/audio/Jump.wav"),
	"Shoot" : preload("res://assets/audio/Shoot.wav"),
}

var created_audio = []

const AUDIO_PLAYER = preload("res://scenes/helper/audio_player.tscn")

func play_sound(name, loop = false, volume_db = 0.0):
	if audio_clips.has(name):
		var new_audio = AUDIO_PLAYER.instance()
		new_audio.should_loop = loop
		new_audio.volume_db = volume_db
		
		add_child(new_audio)
		created_audio.append(new_audio)
		
		new_audio.play_sound(audio_clips[name])

func remove_all():
	for audio in created_audio:
		if audio != null:
			audio.queue_free()
	
	created_audio.clear()
