class_name Hotbar extends Inventory

var selectedSlot: int


func _ready():
	print(selectedSlot)


func select_item(index: int):
	print("SELECT_ITEM!")
	refSlotCntr.get_child(selectedSlot).set_isSelected(false)
	refSlotCntr.get_child(index).set_isSelected(true)
	selectedSlot = index
	
	if refSlotCntr.get_child(selectedSlot).get_child_count() > 0:
		return refSlotCntr.get_child(selectedSlot).get_child(0).itemRef
	else:
		return null
