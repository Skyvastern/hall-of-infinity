extends Control

var enemy = null
var player = null

var pivot = null
var arc = null

var visibility = 0.0
var visibility_speed = 2.0
var show = false setget set_show

var visible_timer = 0.0
const MAX_VISIBLE_TIME = 2.5

func set_enemy(_enemy):
	enemy = _enemy


func _ready():
	player = get_tree().root.get_child(get_tree().root.get_child_count()-1).get_node("Player")
	pivot = $Pivot
	arc = $Pivot/Arc
	
	arc.modulate.a = 0.0
	visibility = arc.modulate.a


func _physics_process(delta):
	handle_visibility(delta)
	
	if enemy != null:
		var dir = enemy.global_transform.origin - player.global_transform.origin
		
		var a = Vector2(player.global_transform.basis.z.x, player.global_transform.basis.z.z)
		var b = Vector2(dir.x, dir.z)
		
		var angle = a.angle_to(b)
		angle = rad2deg(angle)
		
		pivot.rect_rotation = angle


func handle_visibility(delta):
	if show:
		if visibility < 1.0:
			visibility += delta * visibility_speed
			arc.modulate.a = visibility
	else:
		if visibility > 0.0:
			visibility -= delta * visibility_speed
			arc.modulate.a = visibility
		
	if visible_timer > 0.0:
		visible_timer -= delta
		if visible_timer <= 0.0:
			set_show(false)

func set_show(value):
	show = value
	
	if show == true:
		visible_timer = MAX_VISIBLE_TIME
