class_name SlotTEST extends Panel


# Signals
# ------------------------------------------------------------------------------
signal itemChanged
# ------------------------------------------------------------------------------

# Member variables.
# ------------------------------------------------------------------------------
var item : Item
# ------------------------------------------------------------------------------


func _init(slotSize: Vector2 = Vector2(118, 80)):
	custom_minimum_size = slotSize


# Getters
# ------------------------------------------------------------------------------
func get_itemRef():
	return get_child(0).itemRef if get_child_count() > 0 else null

func get_item():
	return item
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func add_item(item):
	if !item:
		return false
	if self.item:
		return false
	
	self.item = item
	item.set_item_owner(self)
	
	# Create the Texture2D for the item being added
	# --------------------------------------------------------------------------
	var itemIcon = TextureRect.new()
	itemIcon.set_texture(item.get_icon())
	add_child(itemIcon)
	# --------------------------------------------------------------------------
	
	# Center our item's texture
	# --------------------------------------------------------------------------
	itemIcon.set_anchors_preset(Control.PRESET_CENTER)
	itemIcon.set_offsets_preset(Control.PRESET_CENTER)
	# --------------------------------------------------------------------------
	
	# Communicate the signal
	# --------------------------------------------------------------------------
	emit_signal("itemChanged", get_item())
	return true
	# --------------------------------------------------------------------------


func remove_item():
	if !item:
		return null
	
	remove_child(get_child(0))
	item.set_owner(null)
	var retItem = item
	item = null
	
	# Communicate the signal
	# --------------------------------------------------------------------------
	emit_signal("itemChanged", get_item())
	return retItem
	# --------------------------------------------------------------------------


func is_empty():
	return item == null
# ------------------------------------------------------------------------------


# Functions specifically for dragging the item's texture
# --------------------------------------------------------------------------------------------------
func _get_drag_data(_position):
	if !item:
		return null
	
	# Set the texture that will be previewed when dragging the item around.
	# --------------------------------------------------------------------------
	var itemDragTexture = TextureRect.new()
	itemDragTexture.set_texture(item.get_icon())
	set_drag_preview(itemDragTexture)
	# --------------------------------------------------------------------------
	
	return item


func _can_drop_data(_position, data):
	# First check if item was not removed from the slot while being dragged [1]
	# --------------------------------------------------------------------------
	if data.get_item_owner().is_empty():
		return
	# --------------------------------------------------------------------------
	
	if !data is Item:
		return false
	
	# Check if drop position is same as the picked-up position
	# --------------------------------------------------------------------------
	if item == data:
		return false
	# --------------------------------------------------------------------------
	
	return true


func _drop_data(_position, data):
	# Store a reference to item's owner
	# --------------------------------------------------------------------------
	var itemOwner = data.get_item_owner()
	# --------------------------------------------------------------------------
	
	# Remove data from its parent slot
	# --------------------------------------------------------------------------
	itemOwner.remove_item()
	# --------------------------------------------------------------------------
	
	# If this slot has a child, remove_at it and add it to the other slot
	# --------------------------------------------------------------------------
	if item:
		var ourItem = item
		remove_item()
		itemOwner.add_item(ourItem)
	# --------------------------------------------------------------------------
	
	# Add the data as a child of this slot
	# --------------------------------------------------------------------------
	add_item(data)
	# --------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------


# Notes or things to have in mind.
# --------------------------------------------------------------------------------------------------
# 1) Checking if the item has been removed while being dragged seems to be fixed by handling it
# only in this method _can_drop_data(). But this is only because when the mouse has been clicked
# (left-click for example) to drop the item, the method _can_drop_data() gets refreshed. Otherwise 
# (if the left-click) would not update this method the fix would also/additionaly have to be 
# implemented in the method _drop_data().
# --------------------------------------------------------------------------------------------------
