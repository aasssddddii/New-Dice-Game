extends TextureButton
class_name Shop_Item

const offset =  Vector2(-28,-28)
var current_sprite
var item_data:Dictionary
#var quantity:int
var active_trade_side:String = ""
@onready var ui_shop = $"../../../.."


# Maybe REMOVE Quantity
func setup_item(input_data:Dictionary,trade_side:String,quantity:int):
	
	
	active_trade_side = trade_side
	
	item_data = input_data
	current_sprite = load(input_data["texture"])
	texture_normal = current_sprite
#	match input_data["item_code"]:
#		0:#Dice
#
#
#			pass
#		1:#Skills OR Player items?
#			pass
#
#	if quantity > 0:
#		get_parent().inventory_data.append(item_data)
	update_quantity()

#func add_item_to_grid_inventory():
#	get_parent().inventory_data.append(item_data)


func _on_button_down():
	if ui_shop.name == "ui_shop":
		ui_shop.change_item_side(self)

func update_quantity():
	var quantity_label = $quantity
	var quantity = get_parent().get_inventory().count(item_data)
	print("Quantity Check: ", quantity)
	
	if quantity > 0:
		quantity_label.text = var_to_str(quantity)
	else:
		queue_free()





