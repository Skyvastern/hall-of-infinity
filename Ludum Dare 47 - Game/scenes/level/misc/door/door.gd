extends Area

var player = null
var game_states = null
var darkness = null

export(int, -1, 1) var flip_normal = 1
var inside_area = false
var can_interact = false

export(String) var next_room = null
var only_once = false

var is_glitched = false

export(bool) var finale = false


func _ready():
	player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")
	game_states = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("GameStates")
	darkness = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Darkness")
	
	connect("body_entered", self, "player_entered")
	connect("body_exited", self, "player_exited")


func _process(delta):
	
	if inside_area:
		var forward = $CollisionShape.global_transform.basis.z.normalized()
		forward *= flip_normal
		var player_forward = player.global_transform.basis.z.normalized()
		var dot = forward.dot(player_forward)
		
		if dot < 0.0:
			can_interact = true
			player.show_interaction_prompt()
		else:
			can_interact = false
			player.hide_interaction_prompt()
	
		if can_interact:
			if Input.is_action_just_pressed("interact"):
				if only_once == false:
					only_once = true
					
					game_states.fade_in()
					yield(get_tree().create_timer(0.5), "timeout")
					switch_to_next_room()


func switch_to_next_room():
	if not is_glitched:
		darkness.reset_darkness()
	
	if finale:
		Global.ludum_dare += 1
		print(Global.ludum_dare)
		if Global.ludum_dare == 47:
			change_next_room_value("res://scenes/level/level_E.tscn")
	
	get_tree().change_scene(next_room)

func change_next_room_value(value):
	is_glitched = true
	next_room = value

func player_entered(body):
	if body.get_name() == "Player":
		if player != null:
			inside_area = true


func player_exited(body):
	if body.get_name() == "Player":
		if player != null:
			inside_area = false
			player.hide_interaction_prompt()
