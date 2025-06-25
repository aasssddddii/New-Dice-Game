extends TextureButton
class_name Shop_Item

var game_manager = GameManager

const offset =  Vector2(-28,-28)
var current_sprite
var item_data:Dictionary
#var quantity:int
var active_trade_side:String = ""
@onready var ui_shop = $"../../../.."

# Maybe REMOVE Quantity
func setup_item(input_data:Dictionary,trade_side:String):
	
	
	active_trade_side = trade_side
	if active_trade_side == "battle" || active_trade_side == "battle_deck" || active_trade_side == "battle_discard":
		ui_shop = $"../../../../.."
	
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


func _on_button_down():#WHEN ITEM IS CLICKED DO THIS
	ui_shop.ui_item_description.close_description()
	#print("parent name: ", ui_shop.name)
	match ui_shop.name:
		"ui_shop":
			ui_shop.change_item_side(self)
		"stats":
			print("is item usable here: ", ui_shop.is_item_usable(item_data))
			if ui_shop.is_item_usable(item_data):
				get_parent().use_map_item(item_data)
		"deck":
			#print("trade side: ", active_trade_side)
			match active_trade_side:
				"deck_inventory":
					if ui_shop.is_item_usable(item_data):
						get_parent().use_map_item(item_data)
						pass
					elif item_data["item_code"] == 0:
						#switch ui side
						get_node_or_null("../../../../deck_grid/ScrollContainer/GridContainer").add_item_to_grid(item_data)
						get_parent().remove_from_grid(item_data)
						#set inventories
						game_manager.player_resource.getset_dice_deck("set",get_node_or_null("../../../../deck_grid/ScrollContainer/GridContainer").inventory_data)
						game_manager.player_resource.getset_inventory("set",get_parent().inventory_data)
					
				"deck":
					if ui_shop.is_item_usable(item_data):
						get_parent().use_map_item(item_data)
						pass
					elif item_data["item_code"] == 0:
						#switch ui side
						get_node_or_null("../../../../inventory_grid/ScrollContainer/GridContainer").add_item_to_grid(item_data)
						get_parent().remove_from_grid(item_data)
						#set inventories
						game_manager.player_resource.getset_dice_deck("set",get_parent().inventory_data)
						game_manager.player_resource.getset_inventory("set",get_node_or_null("../../../../inventory_grid/ScrollContainer/GridContainer").inventory_data)
		"Dice_Battle":
			get_parent().use_battle_item(item_data)
		"dice_altar","upgrade_altar":
			get_parent().remove_from_grid(item_data)
			var temp_dice = game_manager.dice_lib.dice_prefab.instantiate()
			var dice_layer = $"../../../../dice_layer"
			var dice_snap = $"../../../../player_inventory/inventory"
			dice_layer.add_child(temp_dice)
			temp_dice.ui_item_description = ui_shop.ui_item_description
			temp_dice.snap_area = dice_snap
			#temp_dice.last_snap_area = dice_snap
			#temp_dice.get_current_snap_area()
			temp_dice.setup_event_data(item_data)
		"upgrade":
			var main_menu_node = $"../../../../../.."
			match active_trade_side:
				"upgrade_deck":
					#Upgrade clicked Dice
					print("upgrade count = ", main_menu_node.upgrade_dice_count)
					if main_menu_node.upgrade_dice_count < 2:
						#print("Dice in DECK to be upgraded: ", item_data)
						if game_manager.player_resource.dice_deck.any(func(check):return check == item_data):
							var upgrade_dice = game_manager.player_resource.dice_deck[game_manager.player_resource.dice_deck.find(item_data)]
							if upgrade_dice["upgrade_level"] < 8:
								#upgrade dice
								upgrade_dice["upgrade_level"] += 1
								
								main_menu_node.upgrade_dice_count += 1
							else:
								print("DICE MAX LEVEL")
							main_menu_node.open_upgrade()
						else:
							print("ERROR Dice not found")
					elif main_menu_node.upgrade_dice_count == 2:
						if game_manager.player_resource.dice_deck.any(func(check):return check == item_data):
							var upgrade_dice = game_manager.player_resource.dice_deck[game_manager.player_resource.dice_deck.find(item_data)]
							if upgrade_dice["upgrade_level"] < 8:
								#upgrade dice
								upgrade_dice["upgrade_level"] += 1
								
								main_menu_node.close_upgrade()
							else:
								print("DICE MAX LEVEL")
						else:
							print("ERROR Dice not found")
					else:
						print("no more upgrades left")
				"upgrade_inventory":
					#Upgrade clicked Dice
					print("upgrade count = ", main_menu_node.upgrade_dice_count)
					if main_menu_node.upgrade_dice_count < 2:
						#print("Dice in DECK to be upgraded: ", item_data)
						if game_manager.player_resource.inventory.any(func(check):return check == item_data):
							var upgrade_dice = game_manager.player_resource.inventory[game_manager.player_resource.inventory.find(item_data)]
							if upgrade_dice["upgrade_level"] < 8:
								#upgrade dice
								upgrade_dice["upgrade_level"] += 1
								main_menu_node.upgrade_dice_count += 1
							else:
								print("DICE MAX LEVEL")
							print("player inventory now:  ", game_manager.player_resource.inventory)
							main_menu_node.open_upgrade()
						else:
							print("ERROR Dice not found")
					elif main_menu_node.upgrade_dice_count == 2:
						if game_manager.player_resource.inventory.any(func(check):return check == item_data):
							var upgrade_dice = game_manager.player_resource.inventory[game_manager.player_resource.inventory.find(item_data)]
							if upgrade_dice["upgrade_level"] < 8:
								#upgrade dice
								upgrade_dice["upgrade_level"] += 1
								
								main_menu_node.close_upgrade()
							else:
								print("DICE MAX LEVEL")
						else:
							print("ERROR Dice not found")
					else:
						print("no more upgrades left")
#		"dice_altar":
#			print("NO SYSTEM FOR DICE UPGRADE YET!!!")
#			pass
			
			
func update_quantity():
	var quantity_label = $quantity
	#print("parent inventory: ", get_parent().get_inventory())
	var quantity = get_parent().get_inventory().count(item_data)
	if item_data["item_name"] == "ite_pcoi" :#&& active_trade_side == "player":
		quantity = item_data["coin_amount"]
		
	#VVV Needs to be refined to include the items put up on the player side
#	if item_data["item_name"] == "ite_pcoi" && active_trade_side == "player_trade":
#		quantity = ui_shop.shop_side_value
	
#	if item_data["item_code"] == 1 && active_trade_side == "shop":#if skill and in shop
#		quantity_label.visible = false
	
	if quantity > 0 || item_data["item_code"] == 5:#player coin added for testing here
		quantity_label.text = var_to_str(quantity)
	else:
		queue_free()

func _on_mouse_entered():
	#print(ui_shop.name)
	match ui_shop.name:
		"stats":
			var inventory_description_location:Node2D = $"../../../../../../description_locations/inventory"
			ui_shop.ui_item_description.relocate(inventory_description_location)
			ui_shop.ui_item_description.setup_description(item_data)
		"deck":
			if active_trade_side == "deck_inventory":
				var inventory_description_location:Node2D = $"../../../../../../description_locations/deck_inventory"
				ui_shop.ui_item_description.relocate(inventory_description_location)
				ui_shop.ui_item_description.setup_description(item_data)
			else:
				var inventory_description_location:Node2D = $"../../../../../../description_locations/deck"
				ui_shop.ui_item_description.relocate(inventory_description_location)
				ui_shop.ui_item_description.setup_description(item_data)
		"ui_shop":
			ui_shop.ui_item_description.setup_description(item_data)
		"Dice_Battle":
			ui_shop.ui_item_description.setup_description(item_data)
		"dice_altar":
			ui_shop.ui_item_description.setup_description(item_data)
		"charm":
			#print("active trade side: ",active_trade_side)
			var inventory_description_location:Node2D
			if active_trade_side == "skill":
				inventory_description_location = $"../../../../../../description_locations/skills"
			else:
				inventory_description_location = $"../../../../../../description_locations/charm"
			ui_shop.ui_item_description.relocate(inventory_description_location)
			ui_shop.ui_item_description.setup_description(item_data)
		"battle_charm":
			ui_shop.ui_item_description.setup_description(item_data)
		"upgrade_altar":
			ui_shop.ui_item_description.setup_description(item_data)
		"upgrade":
			if active_trade_side == "upgrade_deck":
				var inventory_description_location:Node2D = $"../../../../../../description_locations/deck"
				ui_shop.ui_item_description.relocate(inventory_description_location)
				ui_shop.ui_item_description.setup_description(item_data)
			else:
				var inventory_description_location:Node2D = $"../../../../../../description_locations/deck_inventory"
				ui_shop.ui_item_description.relocate(inventory_description_location)
				ui_shop.ui_item_description.setup_description(item_data)
func _on_mouse_exited():
	ui_shop.ui_item_description.close_description()
