class_name Inventory extends TextureRect


# Member variables
# ------------------------------------------------------------------------------
var refSlotCntr: GridContainer
# ------------------------------------------------------------------------------


# Constructors / Initialzers
# ------------------------------------------------------------------------------
func _ready():
	refSlotCntr = $CenterContainer/SlotContainer
# ------------------------------------------------------------------------------


# Getters
# ------------------------------------------------------------------------------
func get_first_item_of_type(itemType: String):
	for index in get_size():
		if get_slot(index).get_itemRef():
			if get_slot(index).get_itemRef().get_class() == itemType:
				return get_slot(index).get_itemRef()
	return null


func get_item_index(item):
	for index in refSlotCntr.get_child_count():
		if get_slot(index).get_child_count() > 0:
			if get_slot(index).get_child(0).get_itemRef() == item:
				return index
	return -1


func is_full():
	return get_item_count() == get_size()


func get_size():
	return refSlotCntr.get_child_count()


func get_item_count():
	var ctr: int = 0
	
	for index in refSlotCntr.get_child_count():
		if get_slot(index).get_itemRef():
			ctr +=1
	return ctr


func get_slot_container():
	return refSlotCntr


func get_slot(index: int):
	if index < refSlotCntr.get_child_count():
		return refSlotCntr.get_child(index)
	else:
		return null
# ------------------------------------------------------------------------------


# Class related methods
# ------------------------------------------------------------------------------
func add_item(item):
	if !(item is Item):
		return false
	
	for index in get_size():
		if get_slot(index).is_empty():
			get_slot(index).add_ItemTexture(item)
			return true
	
	return false


func remove_item(item):
	if !(item is Item):
		return null
	
	var index = get_item_index(item)
	if index < 0:
		return null
	
	var itemRef = get_slot(index).get_itemRef()
	get_slot(index).delete_ItemTexture()
	
	return itemRef


func delete_item(item):
	var itemRef = remove_item(item)
	if itemRef:
		itemRef.queue_free()
		return true
	
	return false


func item_type_exists(itemType: String):
	for index in get_size():
		if get_slot(index).get_itemRef():
			if get_slot(index).get_itemRef().get_type() == itemType:
				return true
	
	return false
# ------------------------------------------------------------------------------
