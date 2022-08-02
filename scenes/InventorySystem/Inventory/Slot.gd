class_name Slot extends Panel


# Signals
# ------------------------------------------------------------------------------
signal itemChanged
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_itemRef():
	return get_child(0).itemRef if get_child_count() > 0 else null
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func add_ItemTexture(item):
	if get_child_count() > 0:
		return false
	
	# Create the Texture for the item being added
	# --------------------------------------------------------------------------
	var nodeIcon:ItemTexture = ItemTexture.new()
	nodeIcon.itemRef = item
	nodeIcon.texture = item.get_icon()
	# --------------------------------------------------------------------------
	
	add_child(nodeIcon)
	
	# Center our item's texture
	# --------------------------------------------------------------------------
	nodeIcon.set_anchors_preset(Control.PRESET_CENTER)
	nodeIcon.set_margins_preset(Control.PRESET_CENTER)
	# --------------------------------------------------------------------------
	
	# Communicate the signal
	# --------------------------------------------------------------------------
	emit_signal("itemChanged", get_itemRef())
	return true
	# --------------------------------------------------------------------------


func remove_ItemTexture():
	if get_child_count() == 0:
		return null
	
	var retNode = get_child(0)
	remove_child(get_child(0))
	
	# Communicate the signal
	# --------------------------------------------------------------------------
	emit_signal("itemChanged", get_itemRef())
	return retNode
	# --------------------------------------------------------------------------


func delete_ItemTexture():
	if get_child_count() == 0:
		return
	
	var itemTexture = get_child(0)
	remove_child(itemTexture)
	itemTexture.queue_free()
	
	# Communicate the signal
	# --------------------------------------------------------------------------
	emit_signal("itemChanged", get_itemRef())
	# --------------------------------------------------------------------------


func is_empty():
	return get_child_count() == 0
# ------------------------------------------------------------------------------


# Functions specifically for dragging the item's texture
# --------------------------------------------------------------------------------------------------
func get_drag_data(_position):
	if get_child_count() == 0:
		return null
	
	# Create the texture that will be previewed when dragging the item around
	# --------------------------------------------------------------------------
	var copyIconNode = ItemTexture.new()
	copyIconNode.set_itemRef(get_child(0).get_itemRef())
	copyIconNode.set_texture(get_child(0).get_texture())
	set_drag_preview(copyIconNode)
	# --------------------------------------------------------------------------
	
	return get_child(0)


func can_drop_data(_position, data):
	if !data is ItemTexture:
		return false
	
	# Check if drop position is same as the picked-up position
	# --------------------------------------------------------------------------
	if get_child_count() != 0 && data == get_child(0):
		return false
	# --------------------------------------------------------------------------
	
	return true


func drop_data(_position, data):
	# Store a reference to data's parent
	# --------------------------------------------------------------------------
	var dataParent = data.get_parent()
	# --------------------------------------------------------------------------
	
	# Remove data from its parent slot
	# --------------------------------------------------------------------------
	dataParent.remove_child(data)
	# --------------------------------------------------------------------------
	
	# If this slot has a child, remove it and add it to the other slot
	# --------------------------------------------------------------------------
	if get_child_count() > 0:
		var ourChild = get_child(0)
		remove_child(ourChild)
		dataParent.add_child(ourChild)
	# --------------------------------------------------------------------------
	
	# Add the data as a child of this slot
	# --------------------------------------------------------------------------
	add_child(data)
	# --------------------------------------------------------------------------
	
	# Communicate signal on bot slots
	# --------------------------------------------------------------------------
	dataParent.emit_signal("itemChanged", dataParent.get_itemRef())
	emit_signal("itemChanged", get_itemRef())
	# --------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------
