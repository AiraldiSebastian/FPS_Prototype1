class_name Inventory extends TextureRect

var refSlotCntr: GridContainer

func _ready():
	refSlotCntr = $CenterContainer/SlotContainer


func put_item(new_item, forwarding_inventory = null):
	print(self)
	if is_full():
		if forwarding_inventory:
			return forwarding_inventory.put_item(new_item)
		else:
			print("Inventory is full!")
			return false
	
	for index in size():
		if refSlotCntr.get_child(index).get_child_count() == 0:
			refSlotCntr.get_child(index).add_item(new_item)
			return index


func drop_item(playerItem, player):
	if playerItem == null:
		return null
	
	var index = get_item_index(playerItem)
	
	if index < 0:
		return null
	
	var itemNodeTexture = refSlotCntr.get_child(index).remove_item()
	var itemRef = itemNodeTexture.itemRef
	
	# Add weapon to the player's parent (the world most probably)
	player.get_parent().add_child(itemRef)
	itemRef.global_transform = player.global_transform
	itemRef.global_transform.origin.y += 0.5
	
	# Free the texture holding the items icon, not the actual item
	itemNodeTexture.queue_free()

func get_item_index(item):
	for index in refSlotCntr.get_child_count():
		if refSlotCntr.get_child(index).get_child_count() > 0:
			if refSlotCntr.get_child(index).get_child(0).itemRef == item:
				return index
	return -1


func is_full(forwarding_inventory = null):
	if forwarding_inventory:
		return forwarding_inventory.is_full()
	else:
		return get_item_count() == size()


func size():
	return refSlotCntr.get_child_count()

func get_item_count():
	var itemCtr: int = 0
	
	for index in refSlotCntr.get_child_count():
		if refSlotCntr.get_child(index).get_child_count() > 0:
			itemCtr +=1
	
	return itemCtr


func get_slot_container():
	return refSlotCntr
