class_name HotbarMarker

signal itemChanged

var slotContainer: GridContainer
var connectedSlot: HotbarSlot
var connectedHotbar: Hotbar


func _init(hotbar: Hotbar):
	connectedHotbar = hotbar
	slotContainer = hotbar.get_slot_container()


func use_item():
	if connectedSlot.get_itemRef() is WeaponSystem:
		pass
	# This operation with MedicKit is extremely dangerous! If the emited signal doesnt arrive first
	# player will have a reference to a deleted object and program will crash!!!
	elif connectedSlot.get_itemRef() is MedicKit:
		var retHealth = connectedHotbar.get_item_usage(connectedSlot.get_itemRef())
		return retHealth


func select_slot(index: int):
	# Check if index is invalid
	if index < 0 and index >= slotContainer.get_child_count():
		return
	
	# Check if index is already our connectedSlot
	if slotContainer.get_child(index) == connectedSlot:
		return
	
	# If connected to aonther slot, disconnect from it
	if connectedSlot:
		connectedSlot.disconnect("itemChanged", self, "communicate")
		connectedSlot.selected(false)
	
	# Connect to new selected slot
	connectedSlot = slotContainer.get_child(index)
	# warning-ignore:return_value_discarded
	connectedSlot.connect("itemChanged", self, "communicate")
	connectedSlot.selected(true)

func communicate(newItem):
	emit_signal("itemChanged", newItem)
