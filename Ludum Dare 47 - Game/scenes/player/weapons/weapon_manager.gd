extends Spatial

var weapons = {}
var hud = null

var current_weapon
var new_weapon_name

var changing_weapon = false
var unequipped_weapon = false


func _ready():
	hud = get_parent().get_parent().get_node("HUD")
	get_parent().get_node("WallRunRotationHelper/Camera/RayCast").add_exception(owner)
	
	weapons = {
		"Unarmed" : $WeaponUnarmed,
		"Pistol" : $WeaponPistol
	}
	
	for weapon in weapons:
		weapons[weapon].weapon_manager = self
		weapons[weapon].player = owner
		weapons[weapon].ray = get_parent().get_node("WallRunRotationHelper/Camera/RayCast")
		weapons[weapon].visible = true
	
	set_process(false)
	change_weapon("Unarmed")


func _process(delta):
	if changing_weapon:
		if unequipped_weapon == false:
			if current_weapon.unequip_finished() == false:
				return
			
			unequipped_weapon = true
			
			current_weapon = weapons[new_weapon_name]
			current_weapon.equip()
		
		if current_weapon.equip_finished() == false:
			return
		
		changing_weapon = false
		set_process(false)


# Will be called from player.gd
func change_weapon(weapon_name):
	if weapon_name == new_weapon_name: # Here new_weapon_name at this point acts as a current weapon name
		return
	
	new_weapon_name = weapon_name
	changing_weapon = true
	
	# Change Weapons
	if current_weapon != null:
		unequipped_weapon = false
		current_weapon.unequip()
	else:
		unequipped_weapon = true
		current_weapon = weapons[new_weapon_name]
		current_weapon.equip()
	
	set_process(true)


func fire_start():
	if not changing_weapon:
		current_weapon.fire_start()

func fire_stop():
	current_weapon.fire_stop()

func reload_start():
	if not changing_weapon:
		current_weapon.reload_start()

func reload_stop():
	current_weapon.reload_stop()

func update_hud(weapon_data):
	hud.update_weapon_ui(weapon_data)
