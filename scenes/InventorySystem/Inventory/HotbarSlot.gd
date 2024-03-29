class_name HotbarSlot extends Slot


# Member variables
#---------------------------------------------------------------------------------------------------
var selected_tex =	preload("res://scenes/InventorySystem/Inventory/hotbar_marker.png")
var selected_style: StyleBoxTexture = null
#---------------------------------------------------------------------------------------------------


# Constructors / Intializers
#-------------------------------------------------------------------------------
func _ready():
	selected_style = StyleBoxTexture.new()
	selected_style.texture = selected_tex
#-------------------------------------------------------------------------------


# Class related methods
#-------------------------------------------------------------------------------
func selected(_selected: bool):
	if _selected:
		set('theme_override_styles/panel', selected_style)
		emit_signal("itemChanged", get_item())
	else:
		set('theme_override_styles/panel', null)
#-------------------------------------------------------------------------------
