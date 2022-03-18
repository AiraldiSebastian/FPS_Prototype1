extends Spatial

const DAMAGE = 40

const IDLE_ANIM_NAME = "Rifle_idle"
const FIRE_ANIM_NAME = "Rifle_fire"

var is_weapon_enabled = false

var player_node = null

# Ammo
var ammo_in_mag = 50
var spare_ammo = 100
const AMMO_IN_MAG = 50

const CAN_RELOAD = true
const CAN_REFILL = true

const RELOADING_ANIM_NAME = "Rifle_reload"

var weapon_name = "Rifle"

func _ready():
	pass

func fire_weapon():
	var ray = $"../../Camera/RayCast"
	ray.force_raycast_update()
	ammo_in_mag -= 1
	player_node.create_sound("Rifle_shot", ray.global_transform.origin)


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

	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		can_reload = true

	if spare_ammo <= 0 or ammo_in_mag == AMMO_IN_MAG:
		can_reload = false

	if can_reload == true:
		var ammo_needed = AMMO_IN_MAG - ammo_in_mag

		if spare_ammo >= ammo_needed:
			spare_ammo -= ammo_needed
			ammo_in_mag = AMMO_IN_MAG
		else:
			ammo_in_mag += spare_ammo
			spare_ammo = 0

		player_node.animation_manager.set_animation(RELOADING_ANIM_NAME)
		player_node.create_sound("Gun_cock", player_node.camera.global_transform.origin)

		return true

	return false

func equip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		print("Rifle Idle");
		is_weapon_enabled = true
		return true

	if player_node.animation_manager.current_state == "Idle_unarmed":
		print("Rifle Equip : First");
		print(weapon_name + "_equip");
		player_node.animation_manager.set_animation(weapon_name + "_equip")

	return false

func unequip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		if player_node.animation_manager.current_state != "Rifle_unequip":
			player_node.animation_manager.set_animation("Rifle_unequip")

	if player_node.animation_manager.current_state == "Idle_unarmed":
		is_weapon_enabled = false
		return true

	return false


func reset_weapon():
	ammo_in_mag = 50
	spare_ammo = 100
