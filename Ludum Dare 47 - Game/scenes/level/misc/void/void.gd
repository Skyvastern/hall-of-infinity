extends Area

var player = null
var touched = false
var current_scene_location = "res://scenes/level/level_B.tscn"


func _ready():
	player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")
	connect("body_entered", self, "player_entered")


func player_entered(body):
	if body.get_name() == "Player":
		touched = true
		get_tree().call_group("door_area", "change_next_room_value", current_scene_location)
