class_name Weapon
extends Spatial


# ----------------------------------
# Name

export (String) var WEAPON_NAME;
# ----------------------------------

# ----------------------------------
# Damage

export (int) var DAMAGE;
# ----------------------------------

# ----------------------------------
# Owner

var player_node;
# ----------------------------------

# ----------------------------------
# States

var is_weapon_enabled;
# ----------------------------------




func _ready():
	is_weapon_enabled = false;


func equip_weapon():
	if player_node.animation_manager.current_state == WEAPON_NAME + "_idle":
		is_weapon_enabled = true
		return true

	if player_node.animation_manager.current_state == "Idle_unarmed":
		player_node.animation_manager.set_animation(WEAPON_NAME + "_equip")

	return false


func unequip_weapon():
	if player_node.animation_manager.current_state == WEAPON_NAME + "_idle":
		if player_node.animation_manager.current_state != WEAPON_NAME + "_unequip":
			player_node.animation_manager.set_animation(WEAPON_NAME + "_unequip")

	if player_node.animation_manager.current_state == "Idle_unarmed":
		is_weapon_enabled = false
		return true

	return false


func ANIM_IDLE():
	return WEAPON_NAME + "_idle";

func ANIM_USE():
	pass;
