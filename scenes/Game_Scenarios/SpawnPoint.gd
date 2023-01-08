extends Node3D

var counterFrames : int
var weaponChild : FireWeapon
# Called when the node enters the scene tree for the first time.
func _ready():
	counterFrames = 120


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
#	if int(Engine.get_physics_frames()) % counterFrames == 0:
#		call_deferred("add_child", load("res://scenes/Weapons/FireWeapons/aa_50_beowulfTEST.tscn").instantiate())
