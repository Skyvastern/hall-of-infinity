extends Spatial

var weapon_manager = null

var player = null
var ray = null

onready var animation_player = $AnimationPlayer
onready var animation_player_weapon = $CenterAnchor/Pistol/AnimationPlayer

var is_equipped = false
var is_firing = false
var is_reloading = false

const DAMAGE = 10
export(PackedScene) var impact_effect

var ammo_in_mag = 15
const MAG_SIZE = 15



func _ready():
	animation_player.play("Unequip")



func _physics_process(delta):
	if is_firing:
		fire()
	
	if is_reloading:
		reload()

func fire_start():
	if fire() == false:
		return
	
	is_firing = true
	animation_player_weapon.get_animation("Shoot").loop = true
	animation_player_weapon.play("Shoot", -1.0, 1.9)

func fire_stop():
	animation_player_weapon.get_animation("Shoot").loop = false

func fire():
	if not is_reloading:
		if ammo_in_mag > 0:
			return true
	
	fire_stop()
	return false

func fire_bullet():
	$CenterAnchor/MuzzleFlash.emitting = true
	var weapon_data = update_ammo("consume")
	weapon_manager.update_hud(weapon_data)
	
	AudioManager.play_sound("Shoot")
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var body = ray.get_collider()
		
		if body.has_method("bullet_hit"):
			body.bullet_hit(DAMAGE, ray.global_transform.origin)
			
		var impact = Global.instantiate_node(impact_effect, ray.get_collision_point())
		impact.emitting = true


func reload_start():
	if reload() == false:
		return
	
	is_reloading = true
	animation_player_weapon.get_animation("Reload").loop = true
	animation_player_weapon.play("Reload", -1.0, 1.0)

func reload_stop():
	animation_player_weapon.get_animation("Reload").loop = false

func reload():
	if not is_firing:
		if ammo_in_mag < MAG_SIZE:
			var weapon_data = update_ammo("reload")
			weapon_manager.update_hud(weapon_data)
		
		return
	
	reload_stop()
	return false



func equip():
	animation_player.play("Equip", -1.0, 2.0)
	var weapon_data = update_ammo()
	weapon_manager.update_hud(weapon_data)

func unequip():
	animation_player.play("Unequip", -1.0, 2.0)

func equip_finished():
	if is_equipped:
		return true
	else:
		return false

func unequip_finished():
	if is_equipped:
		return false
	else:
		return true




func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Unequip":
			is_equipped = false
		"Equip":
			is_equipped = true
		"Shoot":
			is_firing = false
		"Reload":
			is_reloading = false



func update_ammo(action="Refresh"):
	match action:
		"consume":
			ammo_in_mag -= 1
		
		"reload":
			ammo_in_mag = MAG_SIZE
	
	return ["Pistol", str(ammo_in_mag)]
