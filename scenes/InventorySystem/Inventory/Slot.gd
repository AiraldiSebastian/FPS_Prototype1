class_name Slot extends Panel

var ItemTextureClass = preload("res://scenes/InventorySystem/Inventory/ItemTexture.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_item(item):
	if get_child_count() > 0:
		return false
	
	var nodeIcon = ItemTextureClass.new()
	nodeIcon.itemRef = item
	nodeIcon.texture = item.get_icon()
	add_child(nodeIcon)
	
	return true


func remove_item():
	if get_child_count() == 0:
		return null
	
	var retNode = get_child(0)
	remove_child(get_child(0))
	
	return retNode


func get_drag_data(_position):
	if get_child_count() == 0:
		return null
	
#	print("[PickerContainer] get_drag_data has run, dragging: ", get_node("Icon"))
	var copyIconNode = ItemTextureClass.new()
	copyIconNode.itemRef = get_child(0).itemRef
	copyIconNode.texture = get_child(0).texture
	set_drag_preview(copyIconNode)
	
	return get_child(0)


func can_drop_data(_position, data):
	if !data is TextureRect:
		return false
	
	# Check if drop position is same as the picked-up position, return false if it is
	if get_child_count() != 0 && data == get_child(0):
		print("[TargetContainer] can_drop_data has run, you cant drop at same picked-up position, returning: ", false)
		return false
	
	print("[TargetContainer] can_drop_data has run, returning: ", true)
	return true

func drop_data(_position, data):
	print("[TARGETContainer] drop_data has run, dropping: ", data)
	get_itemRef()
	
	# Check if swap of items has to take place
	if get_child_count() != 0:
		swap_parents(data, get_child(0))
#		# Get ref to our Icon and data parent
#		var ourIcon = get_node("Icon")
#		var dataParent = data.get_parent()
#
#		# Remove both children
#		remove_child(ourIcon)
#		dataParent.remove_child(data)
#
#		# Add children to corresponding controls
#		add_child(data)
#		dataParent.add_child(ourIcon)
	else:
		# THIS CODE SHOULD DEFINITELY BE MODIFIED, MULTIPLE REFERENCES TO SAME OBJECT IS BEING CHANGED HERE, NOT GOOD!!!
		# Check if item parents is selected or if this node is selected
		check_selected_slot(data.get_parent(), self)
		
		data.get_parent().remove_child(data)
		add_child(data)
	get_itemRef()


func get_itemRef():
	if get_child_count() > 0:
		print("ItemRef: ", get_child(0).itemRef)

func swap_parents(firstNode, secondNode):
	# Check if item parents is selected or if this node is selected
	check_selected_slot(firstNode.get_parent(), secondNode.get_parent())
	# Get parents reference
	var firstNodeParent = firstNode.get_parent()
	var secondNodeParent= secondNode.get_parent()
	
	# Remove childs from their parents
	firstNodeParent.remove_child(firstNode)
	secondNodeParent.remove_child(secondNode)
	
	# Add childs to new parents
	firstNodeParent.add_child(secondNode)
	secondNodeParent.add_child(firstNode)


func check_selected_slot(dataNode, selfNode):
	if dataNode.get_type() == "SlotHBarTest":
		# Check if this slot with an item was being selected by the player, remove it if thats the case
		if dataNode.isSelected:
			# Check if the slot where we are puting the item has an item and swap happens
			if selfNode.get_child_count() > 0:
				dataNode.get_parent().get_parent().get_parent().playerOwner.change_weapon(selfNode.get_child(0).itemRef)				
			# If no swap happens, change holding item to null
			else:
				dataNode.get_parent().get_parent().get_parent().playerOwner.change_weapon(null)
	if selfNode.get_type() == "SlotHBarTest":
		print("SelfNode: ", selfNode)
		# Check if this node is being selected by the player, add the new item to player if thats the case
		if selfNode.isSelected:
			selfNode.get_parent().get_parent().get_parent().playerOwner.change_weapon(dataNode.get_child(0).itemRef)


func get_type():
	return "Slot"
