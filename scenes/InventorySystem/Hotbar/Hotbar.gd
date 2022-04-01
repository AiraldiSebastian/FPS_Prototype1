extends TextureRect

var arraySlots = [null, null, null, null, null]
var selectedSlot: int

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(array_size())
	pass # Replace with function body.

func put_item(new_item):
	if !array_isFull():
		for i in arraySlots.size():
			if !arraySlots[i]:
				arraySlots[i] = new_item
				get_child(0).get_child(i).add_item(new_item)
				return i
	else:
		print("Hotbar is full!")


func drop_item(playerItem, player, world):
	var index = get_itemIndex(playerItem)
	if index >= 0:
		get_node("CenterContainer/TextureRect/CenterContainer/SlotContainer").get_child(index).remove_item()
	arraySlots[index] = null
	playerItem.get_parent().remove_child(playerItem)
	world.add_child(playerItem)
	playerItem.global_transform = player.global_transform
	playerItem.global_transform.origin.y += 0.5


func get_itemIndex(item):
	for i in arraySlots.size():
		if arraySlots[i] == item:
			return i
	return null


func select_item(index: int):
	get_child(0).get_child(selectedSlot).set_isSelected(false)
	get_child(0).get_child(index).set_isSelected(true)
	selectedSlot = index
	return arraySlots[selectedSlot]


func is_full():
	return array_size() == arraySlots.size()


func array_size():
	var size: int = 0
	for item in arraySlots:
		if item:
			size += 1
	return size


func array_isFull():
	return array_size() == arraySlots.size()
