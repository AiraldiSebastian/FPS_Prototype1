class_name Weapons extends Spatial

func _init():
	pass

func fire_weapon(player, camera, camera2, rayCast, direct_space_state):
	var directState = direct_space_state
	print("====================================================================")
	print("Theo Player Origin: ", global_transform.origin)
	print("Player Origin: ", player.global_transform.origin)
	print("Camera G_T_Origin: ", camera.global_transform.origin)
	print("Camera G_T_BasisZ: ", camera.global_transform.basis.z)
	print("Camera T_B_Z", camera.transform.basis.z)
	var collision = directState.intersect_ray(camera.global_transform.origin, camera.global_transform.origin + camera.global_transform.basis.z * -20)
	rayCast.global_transform.origin = camera.global_transform.origin
	rayCast.cast_to = Vector3(0, 0, 10)
	camera2.global_transform.origin = camera.global_transform.origin
	
	if collision:
		print(collision.position)
		print(collision.collider.to_string())
	
func _ready():
	print("Weapons READY!")
