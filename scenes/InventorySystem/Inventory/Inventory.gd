class_name Inventory extends TextureRect

var weapon_1 =			preload("res://scenes/Weapons/FireWeapons/AssaultRifle_A.tscn")
var weapon_2 =			preload("res://scenes/Weapons/FireWeapons/HeavyWeapon_F.tscn")
var weapon_3 =			preload("res://scenes/Weapons/FireWeapons/Rifle_A.tscn")
var weapon_4 =			preload("res://scenes/Weapons/FireWeapons/Shotgun.tscn")

var refSlotCntr: GridContainer

var playerOwner

func _ready():
	refSlotCntr = $CenterContainer/SlotContainer
	
	var tmpArray = []
	tmpArray.append(weapon_1)
	tmpArray.append(weapon_2)
	tmpArray.append(weapon_3)
	tmpArray.append(weapon_4)
	tmpArray.append_array(tmpArray)
	
	for i in tmpArray.size():
		put_item(tmpArray[i].instance())

func put_item(new_item):
	if is_full():
		print("Inventory is full!")
		return false
	
	for index in size():
		if refSlotCntr.get_child(index).get_child_count() == 0:
			refSlotCntr.get_child(index).add_item(new_item)
			return index


func drop_item(playerItem, player):
	var index = get_item_index(playerItem)
	if index < 0:
		return null
	
	var itemNode = refSlotCntr.get_child(index).remove_item()
	var itemRef = itemNode.itemRef
	# Check if item is being hold by someone (the player most probably)
	if itemRef.get_parent():
		itemRef.get_parent().remove_child(itemRef)
	
	# Add weapon to the player's parent (the world most probably)
	player.get_parent().add_child(itemRef)
	itemRef.global_transform = player.global_transform
	itemRef.global_transform.origin.y += 0.5
	
	# Free our itemNode
	itemNode.queue_free()

func get_item_index(item):
	for index in refSlotCntr.get_child_count():
		if refSlotCntr.get_child(index).get_child_count() > 0:
			if refSlotCntr.get_child(index).get_child(0).itemRef == item:
				return index
	return null


func is_full():
	return get_item_count() == size()


func size():
	return refSlotCntr.get_child_count()

func get_item_count():
	var itemCtr: int = 0
	
	for index in refSlotCntr.get_child_count():
		if refSlotCntr.get_child(index).get_child_count() > 0:
			itemCtr +=1
	
	return itemCtr
