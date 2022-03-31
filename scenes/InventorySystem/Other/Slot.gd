extends Panel

var default_tex		=	preload("res://scenes/InventorySystem/Other/item_slot_default_background.png")
var empty_tex		=	preload("res://scenes/InventorySystem/Other/item_slot_empty_background.png")

var default_style: StyleBoxTexture	=	null
var empty_style: StyleBoxTexture	=	null

var itemClass = preload("res://scenes/InventorySystem/Other/Item.tscn")
var item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	
	if randi() % 2 == 0:
		item = itemClass.instance()
		add_child(item)
	refresh_style()

func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)


func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	refresh_style()


func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
