class_name HotbarMarker


# Signals
#-------------------------------------------------------------------------------
signal itemChanged
#-------------------------------------------------------------------------------


# Member variables
#-------------------------------------------------------------------------------
var slotContainer: GridContainer
var connectedSlot: HotbarSlot
var connectedHotbar: Inventory
#-------------------------------------------------------------------------------


# Constructors / Initializers
#-------------------------------------------------------------------------------
func _init(hotbar: Inventory):
	connectedHotbar = hotbar
	slotContainer = hotbar.get_slot_container()
#-------------------------------------------------------------------------------


# Getters
#-------------------------------------------------------------------------------
func get_item():
	if connectedSlot:
		return connectedSlot.get_itemRef()
	return null
#-------------------------------------------------------------------------------


# Class related methods
#-------------------------------------------------------------------------------
func select_slot(index: int):
	if index < 0 and index >= slotContainer.get_child_count():
		return
	
	# Check if the slot at this index is already our connectedSlot
	#---------------------------------------------------------------------------
	if slotContainer.get_child(index) == connectedSlot:
		return
	#---------------------------------------------------------------------------
	
	
	# If connected to another slot, disconnect from it
	#---------------------------------------------------------------------------
	if connectedSlot:
		connectedSlot.disconnect("itemChanged", self, "communicate")
		connectedSlot.selected(false)
	#---------------------------------------------------------------------------
	
	# Connect to new selected slot
	#---------------------------------------------------------------------------
	connectedSlot = slotContainer.get_child(index)
	# warning-ignore:return_value_discarded
	connectedSlot.connect("itemChanged", self, "communicate")
	connectedSlot.selected(true)
	#---------------------------------------------------------------------------


func communicate(newItem):
	emit_signal("itemChanged", newItem)
#-------------------------------------------------------------------------------
