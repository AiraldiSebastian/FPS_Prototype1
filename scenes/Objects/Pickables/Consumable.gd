class_name Consumable extends RigidBody

export var charges: int setget set_charges, get_charges

func reduce_charges():
	charges -= 1


func set_charges(new_charges):
	charges = new_charges


func get_charges():
	return charges
