class_name Inventory extends TextureRect

var refSlotCntr: GridContainer
# We could also add a function named get_slot() to not
# call refSlotCntr.get_child(index) always, instead we
# just call get_slot(index) =)

func _ready():
	refSlotCntr = $CenterContainer/SlotContainer

# add_item()
# remove_item()
# use_item()
# drop_item()
# delete_item()
# item_type_exists()
# get_first_item_of_type()
# get_size()
# get_total_items()
# get_item_index()
# get_slot()


func add_item(new_item, forwarding_inventory = null):
	if is_full():
		if forwarding_inventory:
			return forwarding_inventory.add_item(new_item)
		else:
			return false
	
	for index in get_size():
		if refSlotCntr.get_child(index).get_child_count() == 0:
			refSlotCntr.get_child(index).add_ItemTexture(new_item)
			return true


func remove_item(item):
	if !item:
		return null
	
	var index = get_item_index(item)
	
	if index < 0:
		return null
	
	var itemRef = refSlotCntr.get_child(index).get_itemRef()
	refSlotCntr.get_child(index).delete_ItemTexture()
	
	return itemRef


func get_item_usage(playerItem):
	if !playerItem:
		return null
	
	var index = get_item_index(playerItem)
	
	if index < 0:
		print("Inventory - get_item_usage() : MASSIVE ERROR: Player current item does not exist in the inventory!")
		return null
	
	var itemRef = refSlotCntr.get_child(index).get_itemRef()
	var retUsage = itemRef.use()
	
	# Check if item is a consumable
	if itemRef is Consumable:
		print("Yes item is a Consumable")
		# If item has only one charge, after using it, it should be deleted
		if itemRef.get_charges() == 0:
			delete_item(itemRef)
	
	return retUsage


func drop_item(item, player):
	var itemRef = remove_item(item)
	
	if !itemRef:
		return false
	
	# Set where the item should spawn (players mid body for now)
	var newTransform: Transform = player.transform
	newTransform.origin.y += player.transform.origin.y / 2
	itemRef.set_global_transform(Transform.IDENTITY)
	itemRef.set_transform(newTransform)
	
	
	# Add item to the player's parent (the world for now)
	player.get_parent().add_child(itemRef)
	itemRef.set_sleeping(false)
	return true


func delete_item(item):
	var itemRef = remove_item(item)
	if itemRef:
		itemRef.queue_free()


func item_type_exists(itemClass: String):
	for index in get_size():
		if refSlotCntr.get_child(index).get_itemRef().get_type() == itemClass:
			return true
	return false


func get_first_item_of_type(itemClass: String):
	for index in get_size():
		if refSlotCntr.get_child(index).get_itemRef():
			if itemClass == "Ammo":
				if refSlotCntr.get_child(index).get_itemRef() is Ammo:
					return refSlotCntr.get_child(index).get_itemRef()
			elif itemClass == "MedicKit":
				if refSlotCntr.get_child(index).get_itemRef() is MedicKit:
					return refSlotCntr.get_child(index).get_itemRef()
	return null


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
		return get_total_items() == get_size()


func get_size():
	return refSlotCntr.get_child_count()


func get_total_items():
	var ctr: int = 0
	
	for index in refSlotCntr.get_child_count():
		if refSlotCntr.get_child(index).get_child_count() > 0:
			ctr +=1
	return ctr


func get_slot_container():
	return refSlotCntr


func get_slot(index: int):
	if refSlotCntr.get_child_count() > 0:
		return refSlotCntr.get_child(index)
	else:
		return null


# Older functions
# --------------------------------------------------------------------------------------------------

#func put_item(new_item, forwarding_inventory = null):
#	print(self)
#	if is_full():
#		if forwarding_inventory:
#			return forwarding_inventory.put_item(new_item)
#		else:
#			print("Inventory is full!")
#			return false
#
#	for index in get_size():
#		if refSlotCntr.get_child(index).get_child_count() == 0:
#			refSlotCntr.get_child(index).add_item(new_item)
#			return index


#func drop_item(playerItem, player):
#	if playerItem == null:
#		return null
#
#	var index = get_item_index(playerItem)
#
#	if index < 0:
#		return null
#
#	var itemNodeTexture = refSlotCntr.get_child(index).remove_item()
#	var itemRef = itemNodeTexture.itemRef
#
#	# Add weapon to the player's parent (the world most probably)
##	itemRef.global_transform = player.global_transform
##	itemRef.global_transform.origin.y += 1
#	itemRef.global_transform = Transform.IDENTITY
#	itemRef.transform = player.transform
#	itemRef.transform.origin.y += 1
#	player.get_parent().add_child(itemRef)
#	itemRef.set_sleeping(false)
##	itemRef.print_sleepMode()
##	itemRef.get_info()
#
#	# Free the texture holding the items icon, not the actual item
#	itemNodeTexture.queue_free()


#func search_item_and_use(item: String):
#	if item == "Ammo":
#		for index in refSlotCntr.get_child_count():
#			if refSlotCntr.get_child(index).get_itemRef() is Ammo:
#				var retAmmo = use_item(refSlotCntr.get_child(index).get_itemRef())
#				return retAmmo
#	return false

# --------------------------------------------------------------------------------------------------
