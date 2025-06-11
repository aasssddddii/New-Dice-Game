extends Button

var game_manager = GameManager

var limbo_item_data



func setup_limbo_item(input_data:Dictionary):
	visible = true
	limbo_item_data = input_data
	print("limbo item data now: ", limbo_item_data)
	
	
func release_limbo_item():
	visible = false
	limbo_item_data = null
	
func give_player_limbo_item():
	game_manager.player_resource.inventory.append(limbo_item_data)
	$"../display_menu/items".setup_inventory(game_manager.player_resource.getset_inventory("get_battle",null),"dice_battle")
	$"../..".start_fate_fragment(false)
	release_limbo_item()

func _on_button_down():
	give_player_limbo_item()
