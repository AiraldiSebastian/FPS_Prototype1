extends Control

signal drop_item

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
	emit_signal("drop_item", data.itemRef)
