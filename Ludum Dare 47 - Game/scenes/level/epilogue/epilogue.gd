extends Control

var player

var dialogs = [
	"Falcon: So you've finally reached here... huh?",
	"Falcon: If you have not already guessed, then it was a test...",
	"Falcon: Yes you hear it right, I wanted to test your mental strength and state of mind, under stressful conditions!",
	"Falcon: Not many pass this test, and lose their mind after a while...",
	"Falcon: But you are not one of those, because you have a true warrior spirit!",
	"Falcon: And as a reward, you've been promoted soldier!",
	"Falcon: Now I gotta go, I have some important business to do...",
	"Falcon: See you later kid, bye bye!"
]


func _ready():
	
	player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")
	player.is_out_of_control = true
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	$AnimationPlayer.play("Fade_In")
	
	yield(get_tree().create_timer(0.2), "timeout")
	next_dialog(0)
	
	yield(get_tree().create_timer(3.5), "timeout")
	next_dialog(1)
	
	yield(get_tree().create_timer(3.5), "timeout")
	next_dialog(2)
	
	yield(get_tree().create_timer(5.0), "timeout")
	next_dialog(3)
	
	yield(get_tree().create_timer(4.0), "timeout")
	next_dialog(4)
	
	yield(get_tree().create_timer(5.0), "timeout")
	next_dialog(5)
	
	yield(get_tree().create_timer(3.5), "timeout")
	next_dialog(6)
	
	yield(get_tree().create_timer(3.5), "timeout")
	next_dialog(7)
	
	yield(get_tree().create_timer(3.5), "timeout")
	end_dialog()


func next_dialog(index):
	$AnimationPlayer.play("Type")
	$DialogBox/Label.text = dialogs[index]


func end_dialog():
	$AnimationPlayer.play("Fade_Out")
	
	player.is_out_of_control = false
