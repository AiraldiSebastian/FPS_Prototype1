class_name Inventory extends TextureRect

var slotContainer : GridContainer
var switch = true

func _init(p_typeOfSlot : SlotType = SlotType.NormalSlot, p_numberOfSlots : int = 20, p_numberOfColumns: int = 5, p_slotSize: Vector2 = Vector2(118, 80)):
	# Create and configure inventory subtree.
	# --------------------------------------------------------------------------
	set_texture(load("res://scenes/InventorySystem/Inventory/inventory_background1.png"))
	
	add_child(CenterContainer.new())
	
	slotContainer = GridContainer.new()
	slotContainer.set_columns(p_numberOfColumns)
	get_child(0).add_child(slotContainer)
	
	# Chose type of Slot for this Inventory
	# ----------------------------------
	match(p_typeOfSlot):
		SlotType.NormalSlot:
			for i in p_numberOfSlots:
				slotContainer.add_child(Slot.new(p_slotSize))
		SlotType.HotbarSlot:
			for i in p_numberOfSlots:
				slotContainer.add_child(HotbarSlot.new(p_slotSize))
	# ----------------------------------
	# --------------------------------------------------------------------------


func _ready():
	# Keep configuring subtree here.
	# ------------------------------
	# Resize inventory.
	set_size(Vector2(slotContainer.get_size().x + 40, slotContainer.get_size().y + 40))
	get_child(0).set_size(slotContainer.get_size() + Vector2(40,40))
	# ------------------------------


# Enums.
# ------------------------------------------------------------------------------
enum SlotType {
	NormalSlot,
	HotbarSlot
}
# ------------------------------------------------------------------------------


# Functions an inventory should provide:
# 01) add_item
# 02) remove_item
# 03) get_item
# 04) get_size
# 05) is_full
# 06) get_space_available

# Class related methods
# ------------------------------------------------------------------------------
func add_item(p_item: Item):
	for i in get_inventory_size():
		if get_slot(i).is_empty():
			get_slot(i).add_item(p_item)
			return true
	return false


func remove_item(p_item: Item):
	for i in slotContainer.get_child_count():
		if get_slot(i).get_item() == p_item:
			return get_slot(i).remove_item()
	return null


func get_item(p_index: int):
	if get_slot(p_index):
		return get_slot(p_index).get_item()
	return null


func get_space_available():
	var ctr = 0
	for i in slotContainer.get_child_count():
		if get_slot(i).is_empty():
			ctr += 1
	return ctr


func get_inventory_size():
	return slotContainer.get_child_count()


func is_full():
	return get_space_available() == 0

func get_slot_container():
	return slotContainer
# ------------------------------------------------------------------------------


# Class helper methods
# ------------------------------------------------------------------------------
func get_slot(p_index: int):
	if p_index < slotContainer.get_child_count():
		return slotContainer.get_child(p_index)
	else:
		return null
# ------------------------------------------------------------------------------
