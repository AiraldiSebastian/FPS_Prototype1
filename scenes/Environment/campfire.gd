extends Node3D

var Fire_Area : Area3D
var timer: int = 60
var DAMAGE: int = 10
var unitInFireArea : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	# Area3D of detection/attack
	# ----------------------------------
	Fire_Area = $Fire_Area
	# warning-ignore:return_value_discarded
	Fire_Area.connect("body_entered",Callable(self,"add_unit"))
	# warning-ignore:return_value_discarded
	Fire_Area.connect("body_exited",Callable(self,"remove_unit"))
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _physics_process(_delta):
	if Engine.get_physics_frames() % timer == 0:
		for unit in unitInFireArea:
			burn(unit)


func burn(unit):
	unit.get_healthSystem().take_damage(DAMAGE)


func add_unit(unit):
	if unit is CharacterBody3D:
		unitInFireArea.append(unit)

func remove_unit(unit):
	if unit is CharacterBody3D:
		unitInFireArea.erase(unit)
