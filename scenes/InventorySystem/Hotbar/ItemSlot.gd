extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var randInt:int = randi() % 4
	match(randInt):
		0:
			$TextureRect.texture = load("res://assets/Weapons/FireWeapons/AssaultRifle_A/AssaultRifle_A_Icon.png")
		1:
			$TextureRect.texture = load("res://assets/Weapons/FireWeapons/HeavyGun/HeavyGun_A_Icon.png")
		2:
			$TextureRect.texture = load("res://assets/Weapons/FireWeapons/Rifle/Rifle_Icon.png")
		3:
			$TextureRect.texture = load("res://assets/Weapons/FireWeapons/Shotgun/Shotgun_Icon.png")
