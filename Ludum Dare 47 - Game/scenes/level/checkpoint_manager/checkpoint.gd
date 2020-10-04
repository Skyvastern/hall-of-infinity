extends Area


func _on_Checkpoint_body_entered(body):
	if body.get_name() == "Player":
		get_parent().current_checkpoint = self
