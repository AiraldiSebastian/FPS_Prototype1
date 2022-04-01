class_name SlotHBarTest extends Slot

var selected_tex =	preload("res://scenes/InventorySystem/Hotbar/hotbar_marker.png")
var selected_style: StyleBoxTexture = null
var isSelected: bool = false

func _ready():
	selected_style = StyleBoxTexture.new()
	selected_style.texture = selected_tex
	

func set_isSelected(value: bool):
	isSelected = value
	if isSelected:
		self.set('custom_styles/panel', selected_style)
	else:
		set('custom_styles/panel', null)


func get_type():
	return "SlotHBarTest"
