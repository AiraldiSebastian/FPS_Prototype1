extends Control

var hotbar: TextureRect
var inventory: TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	hotbar = $Inventory/Hotbar
	inventory = $Inventory/Inventory


func can_drop_data(_position, data):
	if !data is TextureRect:
		return false
	
	return true

func drop_data(_position, data):
	hotbar.drop_item(data.itemRef, get_parent())
	inventory.drop_item(data.itemRef, get_parent())
