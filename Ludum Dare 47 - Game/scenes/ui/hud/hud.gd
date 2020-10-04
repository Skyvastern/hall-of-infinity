extends Control

var health_ui
var weapon_ui
var infinity_ui

func _enter_tree():
	health_ui = $BG/MarginContainer/VBoxContainer/Upper/Health
	weapon_ui = $BG/MarginContainer/VBoxContainer/Lower/Ammo
	infinity_ui = $BG/MarginContainer/VBoxContainer/Lower/Infinity


# Will be called from weapon manager
func update_weapon_ui(weapon_info):
	var weapon_name = weapon_info[0]
	
	if weapon_name == "Unarmed" or weapon_name == "Melee":
		weapon_ui.text = weapon_name
		infinity_ui.text = ""
		return
	
	var ammo_in_mag = weapon_info[1]
	weapon_ui.text = weapon_name + ":" + str(ammo_in_mag) + "/"
	infinity_ui.text = "∞"


# Will be called from health
func update_health_ui(health_info):
	health_ui.text = "Health: " + health_info[0]
