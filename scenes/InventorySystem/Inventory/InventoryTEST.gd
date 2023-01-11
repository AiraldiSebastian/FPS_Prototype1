extends TextureRect

var slotContainer : GridContainer

func _init(numberOfSlots: int = 20, numberOfColumns: int = 5, slotSize: Vector2 = Vector2(118, 80)):
	# Create and configure inventory subtree.
	# ---------------------------------------
	set_texture(load("res://scenes/InventorySystem/Inventory/inventory_background2.png"))
	
	add_child(CenterContainer.new())
	
	slotContainer = GridContainer.new()
	slotContainer.set_columns(numberOfColumns)
	get_child(0).add_child(slotContainer)
	
	for i in numberOfSlots:
		slotContainer.add_child(SlotTEST.new(slotSize))
	# ---------------------------------------
	
# Called when the node enters the scene tree for the first time.
func _ready():
	# Keep configuring subtree here.
	# ------------------------------
	# Resize inventory.
	set_custom_minimum_size(Vector2(slotContainer.get_size().x + 40, slotContainer.get_size().y + 40))
	get_child(0).set_size(get_custom_minimum_size())
	# ------------------------------


# Functions an inventory should provide:
# 01) add_item
# 02) remove_item
# 03) get_item
# 04) get_size
# 05) is_full
# 06) get_space_available

# Class related methods
# ------------------------------------------------------------------------------
func add_item(item: Item):
	for i in self.get_size():
		if get_slot(i).is_empty():
			get_slot(i).add_item(item)
			return true
	return false


func remove_item(item: Item):
	for i in slotContainer.get_child_count():
		if get_slot(i).get_item() == item:
			return get_slot(i).remove_item()
	return null


func get_item(index):
	if get_slot(index):
		return get_slot(index).get_item()
	return null


func get_space_available():
	var ctr = 0
	for i in slotContainer.get_child_count():
		if !slotContainer.is_empty():
			ctr += 1
	return ctr


func get_size():
	return slotContainer.get_child_count()


func is_full():
	return get_space_available() == 0
# ------------------------------------------------------------------------------


# Class helper methods
# ------------------------------------------------------------------------------
func get_slot(index: int):
	if index < slotContainer.get_child_count():
		return slotContainer.get_child(index)
	else:
		return null
# ------------------------------------------------------------------------------
