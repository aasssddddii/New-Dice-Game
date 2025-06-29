extends TextureButton

#var current_sprite
var item_data:Dictionary
var ui_item_description
var game_manager = GameManager

# Called when the node enters the scene tree for the first time.
func setup_item(input_data:Dictionary):
	var quantity = $quantity
	quantity.visible = false
	item_data = input_data
	texture_normal  = load(input_data["texture"])
	ui_item_description = get_node_or_null("../../ui_item_desciption")
	if ui_item_description == null:#on riddle event or more specifically just not ^^^
		ui_item_description = get_node_or_null("../../../../ui_item_desciption")
		
	if input_data["item_code"] == 5:
		update_coin_quantity(input_data["coin_amount"])


func _on_mouse_entered():
	manage_description(item_data,true)


func _on_mouse_exited():
	ui_item_description.close_description()


func manage_description(input_data,make_visible:bool):
	
	if make_visible:
		match input_data["item_code"]:
			0:#dice
				#print("SANITY CHECK input data: ", input_data)
				ui_item_description.setup_description({
					"item_code":input_data["item_code"],
					"item_name":input_data["item_name"],
					"long_name":input_data["long_name"],
					"description":input_data["description"],
					"upgrade_level":input_data["upgrade_level"]
					})
			2:#item
				ui_item_description.setup_description({
					"item_code":input_data["item_code"],
					"item_name":input_data["item_name"],
					"long_name":input_data["long_name"],
					"description":input_data["description"]
					})
			4:#charm
				ui_item_description.setup_description({
					"item_code":input_data["item_code"],
					"item_name":input_data["item_name"],
					"long_name":input_data["long_name"],
					"description":input_data["description"]
					})
			5:#gold
				ui_item_description.setup_description({
					"item_code":input_data["item_code"],
					"item_name":input_data["item_name"],
					"long_name":input_data["long_name"],
					"description":input_data["description"]
					})
			
	else:
		ui_item_description.close_description()

func update_coin_quantity(amount:int):
	var quantity = $quantity
	quantity.text = var_to_str(amount)
	quantity.visible = true
	
