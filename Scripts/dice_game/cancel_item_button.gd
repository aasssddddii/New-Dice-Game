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
	if limbo_item_data != null:
		game_manager.player_resource.inventory.append(limbo_item_data)
		$"../display_menu/ScrollContainer/items".setup_inventory(game_manager.player_resource.getset_inventory("get_battle",null),"battle")
		$"../..".close_item_selections()
		release_limbo_item()

func _on_button_down():
	give_player_limbo_item()
