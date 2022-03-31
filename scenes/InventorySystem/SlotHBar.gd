extends Panel

var selected_tex =	preload("res://scenes/InventorySystem/Hotbar/image.png")

var isSelected: bool = false

var selected_style: StyleBoxTexture = null

var item = null


# Called when the node enters the scene tree for the first time.
func _ready():
	selected_style = StyleBoxTexture.new()
	selected_style.texture = selected_tex
	
	item = Node2D.new()
	item.add_child(TextureRect.new())
	add_child(item)
	get_child(0).transform.origin = Vector2(3, 3)


func set_isSelected(value: bool):
	isSelected = value
	if isSelected:
		set('custom_styles/panel', selected_style)
	else:
		set('custom_styles/panel', null)

func put_item(new_item):
	item.get_child(0).texture = new_item.get_icon()
#	Create a new Node2D with TextureRect as child and set its texture to the items icon.  
#	item = Node2D.new()
#	item.add_child(TextureRect.new())
#	item.get_child(0).texture = new_item.get_icon()
	
#	Add this new Node2D to the Slot Panel and center it
#	add_child(item)
#	get_child(0).transform.origin = Vector2(3, 3)

#func refresh_style():
#	if isSelected:
#		set('custom_styles/panel', selected_style)
#	else:
#		set('custom_styles/panel', null)


func drop_item():
	if item.get_child(0).texture:
		item.get_child(0).texture = null
		
		


func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
#	refresh_style()


func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
#	refresh_style()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
