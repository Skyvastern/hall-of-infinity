extends Spatial

var weapon_manager = null
var player = null
var ray = null

func fire_start():
	pass

func fire_stop():
	pass

func fire():
	pass

func reload_start():
	pass

func reload_stop():
	pass

func reload():
	pass


func equip():
	var weapon_data = update_ammo()
	weapon_manager.update_hud(weapon_data)

func unequip():
	pass

func equip_finished():
	return true

func unequip_finished():
	return true

func update_ammo():
	return ["Unarmed"]
