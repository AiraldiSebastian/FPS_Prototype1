extends Control

signal drop_item


func _can_drop_data(_position, data):
	if !data is TextureRect:
		return false
	
	return true

func _drop_data(_position, data):
	emit_signal("drop_item", data.itemRef)
