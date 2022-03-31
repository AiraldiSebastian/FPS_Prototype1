extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var randInt:int = randi() % 4
	match(randInt):
		0:
			$TextureRect.texture = load("res://scenes/InventorySystem/Brown Boots.png")
		1:
			$TextureRect.texture = load("res://scenes/InventorySystem/Brown Shirt.png")
		2:
			$TextureRect.texture = load("res://scenes/InventorySystem/Tree Branch.png")
		3:
			$TextureRect.texture = load("res://scenes/InventorySystem/Iron Sword.png")
