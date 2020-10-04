extends Spatial

onready var player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")

export(NodePath) var hud_path
var hud

func _enter_tree():
	hud = get_node(hud_path)

func decrease_health(amount):
	Global.health -= amount
	
	if Global.health <= 0:
		Global.health = 0
		player.farewell()
	
	if hud != null:
		hud.update_health_ui(get_health_data())

func increase_health(amount):
	Global.health += amount
	if hud != null:
		hud.update_health_ui(get_health_data())

func reset_health():
	Global.health = Global.MAX_HEALTH
	if hud != null:
		hud.update_health_ui(get_health_data())

func get_health_data():
	return [str(Global.health)]
