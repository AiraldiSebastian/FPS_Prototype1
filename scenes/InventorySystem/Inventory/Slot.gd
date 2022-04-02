class_name Slot extends Panel

signal itemChanged
var ItemTextureClass = preload("res://scenes/InventorySystem/Inventory/ItemTexture.gd")


func add_item(item):
	if get_child_count() > 0:
		return false
	
	# Create the Texture for the item being added
	var nodeIcon = ItemTextureClass.new()
	nodeIcon.itemRef = item
	nodeIcon.texture = item.get_icon()
	
	add_child(nodeIcon)
	
	nodeIcon.set_anchors_preset(Control.PRESET_CENTER)
	nodeIcon.set_margins_preset(Control.PRESET_CENTER)
	
	# Communicate the signal
	emit_signal("itemChanged", get_itemRef())
	return true


func remove_item():
	if get_child_count() == 0:
		return null
	
	var retNode = get_child(0)
	remove_child(get_child(0))
	
	# Communicate the signal
	emit_signal("itemChanged", get_itemRef())
	return retNode


func get_drag_data(_position):
	if get_child_count() == 0:
		return null
	
	# Create the Texture that will be previewed when moving the item
	var copyIconNode = ItemTextureClass.new()
	copyIconNode.itemRef = get_child(0).itemRef
	copyIconNode.texture = get_child(0).texture
	set_drag_preview(copyIconNode)
	
	return get_child(0)


func can_drop_data(_position, data):
	if !data is TextureRect:
		return false
	
	# Check if drop position is same as the picked-up position
	if get_child_count() != 0 && data == get_child(0):
		return false
	
	return true

func drop_data(_position, data):
	# Store a reference to data's parent
	var dataParent = data.get_parent()
	
	# Remove data from its parent Slot
	dataParent.remove_child(data)
	
	# If this slot has a child, add it to the other slot and remove it from this
	if get_child_count() > 0:
		var ourChild = get_child(0)
		remove_child(ourChild)
		dataParent.add_child(ourChild)
	
	# Add the data as a child of this slot
	add_child(data)
	
	# Communicate the signal
	dataParent.emit_signal("itemChanged", dataParent.get_itemRef())
	emit_signal("itemChanged", get_itemRef())


func get_itemRef():
	return get_child(0).itemRef if get_child_count() > 0 else null
