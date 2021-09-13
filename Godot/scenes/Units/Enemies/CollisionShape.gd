extends CollisionShape

export (NodePath) var path_to_zombie

func _ready():
	pass

func bullet_hit(damage, bullet_hit_pos):
	if path_to_zombie != null:
		get_node(path_to_zombie).bullet_hit(damage, bullet_hit_pos)
