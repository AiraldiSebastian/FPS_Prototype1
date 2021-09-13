extends Weapon
class_name FireWeapon


# ----------------------------------
# Ammo

export (int) var MAX_AMMO;
export (int) var MAX_MAG_AMMO;
var spare_ammo : int;
var ammo_in_mag : int;
# ----------------------------------

# ----------------------------------
# RayCast

export (NodePath) onready var ray = get_node(ray);
# ----------------------------------


func _ready():
	reset_weapon();
	pass


func is_usable():
	return true if ammo_in_mag > 0 	else false;


func fire_weapon():
	ray.force_raycast_update()
	ammo_in_mag -= 1
	player_node.create_sound(WEAPON_NAME + "_shot", ray.global_transform.origin)


	if ray.is_colliding():
		print(ray.get_collider())
		print("Colliding");
		var body = ray.get_collider()
		
		if body == player_node:
			pass
		elif body.has_method("bullet_hit"):
			body.bullet_hit(DAMAGE, ray.global_transform)

func reload_weapon():
	var can_reload = false
	
	if player_node.animation_manager.current_state == WEAPON_NAME + "_idle":
		can_reload = true
		
	if spare_ammo <= 0 or ammo_in_mag == MAX_MAG_AMMO:
		can_reload = false
		
	if can_reload == true:
		var ammo_needed = MAX_MAG_AMMO - ammo_in_mag
		
		if spare_ammo >= ammo_needed:
			spare_ammo -= ammo_needed
			ammo_in_mag = MAX_MAG_AMMO
		else:
			ammo_in_mag += spare_ammo
			spare_ammo = 0
			
		player_node.animation_manager.set_animation(WEAPON_NAME + "_reload")
		player_node.create_sound("Gun_cock", player_node.camera.global_transform.origin)
		
		return true
		
	return false


func reset_weapon():
	ammo_in_mag = MAX_AMMO;
	spare_ammo = MAX_MAG_AMMO;


func ANIM_USE():
	return WEAPON_NAME + "_fire";

func ANIM_RELOAD():
	return WEAPON_NAME + "_reload";
