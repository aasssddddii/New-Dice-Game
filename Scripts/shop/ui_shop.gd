extends Node2D
#class_name Shop
#
#enum ShopType{
#	DICE,
#	UPGRADE,
#	ITEM,
#	COMBO
#}

var game_manager = GameManager

var template_shop_container = load("res://Prefabs/shop/shop_container_template.tscn")
@onready var shop_side_inventory = $shop_side
@onready var player_side_inventory = $player_side
@onready var shop_side_trade = $shop_trade/ScrollContainer/GridContainer
@onready var player_side_trade = $player_trade/ScrollContainer/GridContainer
@onready var player_trade_label = $player_ui/player_trade_label
@onready var shop_trade_label = $player_ui/shop_trade_label
@onready var shop_submit_button = $player_ui/Button

@export var ui_item_description:ColorRect

var shop_side_grid_container
var player_side_grid_container

var current_shop_type:level_gen.Shop_Type
var shop_data:Dictionary



func setup_shop(input_data:Dictionary):
	shop_data = input_data
	create_shop()
	setup_player_side()
	update_trade_values()



func create_shop():
	var export_inventory:Array[Dictionary]
	var shop_name:String
	match shop_data["shop_type"]:
		level_gen.Shop_Type.DICE:
			shop_name = "Dice Shop"
		level_gen.Shop_Type.SKILL:
			shop_name = "Skill Shop"
#		level_gen.Shop_Type.UPGRADE:
#			shop_name = "Upgrade"
		level_gen.Shop_Type.ITEM:
			shop_name = "Item Shop"
	
	for item in shop_data["inventory"]:
		export_inventory.append(item)
	
	for item in export_inventory:
		print("next dice to make in shop:", item)
	shop_side_grid_container = create_named_grid_container(export_inventory,shop_side_inventory,shop_name,"shop")


func setup_player_side():#sets up player side of shop
#	create_dicedeck_grid()
#	if !game_manager.player_resource.inventory.is_empty():
	create_player_inventory()
	



#func create_dicedeck_grid():
#	var converted_dice_deck = game_manager.player_resource.getset_dice_deck("get_converted",null)
#	player_side_grid_container = create_named_grid_container(converted_dice_deck,player_side_inventory,"Dice Deck","player")
	
func create_player_inventory():
	var inventory_data = game_manager.player_resource.getset_inventory("get",null)
	player_side_grid_container = create_named_grid_container(inventory_data,player_side_inventory,"Inventory","player")
	

func create_named_grid_container(grid_inventory:Array[Dictionary],parent_node,title:String,trade_side:String):
	var next_scroll_container = template_shop_container.instantiate()
	next_scroll_container.name = title
	var grid_container = next_scroll_container.get_node_or_null("GridContainer")
	
	grid_container.setup_inventory(grid_inventory,trade_side)
	parent_node.add_child(next_scroll_container)
	return grid_container

func change_item_side(item:Shop_Item):
	var item_data = item.item_data
	var move_side
	var from_side = item.get_node_or_null("../../..").name
	#print("item parent name: ", item.get_parent().name)
	
	match from_side:
		"shop_side":
			move_side = "shop_trade"
			shop_side_grid_container.manage_inventory("remove",item_data)
		"player_side":
			move_side = "player_trade"
			player_side_grid_container.manage_inventory("remove",item_data)
		"shop_trade":
			move_side = "shop_side"
			shop_side_trade.manage_inventory("remove",item_data)
		"player_trade":
			move_side = "player_side"
			player_side_trade.manage_inventory("remove",item_data)
			
	item.get_node_or_null("..").update_grid()
	#print("item clicked on ",item.active_trade_side," side moving to ", move_side)

	
	match move_side:
		"shop_side":
			shop_side_grid_container.add_item_to_grid(item_data)
		"player_side":
			player_side_grid_container.add_item_to_grid(item_data)
		"shop_trade":
			shop_side_trade.add_item_to_grid(item_data)
		"player_trade":
			player_side_trade.add_item_to_grid(item_data)
	update_trade_values()
			
	
func update_trade_values():
	var player_side_value:int
	var shop_side_value:int
	#calculate player side
	for item in player_side_trade.inventory_data:
		print("player item price: " , item["price"]/2)
		player_side_value += item["price"]/2
		
	for item in shop_side_trade.inventory_data:
		shop_side_value += item["price"]
		
		
	if player_side_value <=0:
		player_trade_label.visible = false
	else:
		player_trade_label.visible = true
	
	
	if shop_side_value <= 0:
		shop_trade_label.visible = false
	else:
		shop_trade_label.visible = true
		
	if player_side_value < shop_side_value || shop_side_value == 0:
		shop_submit_button.visible = false
	else:
		shop_submit_button.visible = true
		
		
	player_trade_label.text = "$ " + var_to_str(player_side_value)
	shop_trade_label.text = "$ " + var_to_str(shop_side_value)
	
func close_shop():
	var player_node = $"../.."
	player_node.manage_camera("map_reset")
	queue_free()

func _on_close_button_down():
	close_shop()


func _on_button_button_down():#SUBMIT button
	match shop_data["shop_type"]:
		level_gen.Shop_Type.DICE:#VVV Change from dice deck to inventory when ready , May be in creation function
				var combo_inventory = player_side_inventory.get_node_or_null("Inventory/GridContainer").inventory_data + shop_side_trade.inventory_data
				var converted_inventory:Array[Dictionary]
				for item_data in combo_inventory:
					match item_data["item_code"]:
						0:#Dice
							if game_manager.dice_lib.all_dice[item_data["item_name"]] == item_data:
								print("defualt dice detected")
								converted_inventory.append({
									"item_code":0,
									"default":true,
									"item_name":item_data["item_name"]
									})
						1:#Skills
							print("item data: ", item_data)
							pass
						2:#Items
							print("item data: ", item_data)
							pass
						
				game_manager.player_resource.getset_inventory("set",converted_inventory)
		level_gen.Shop_Type.SKILL:
			print("SKILL Evaluatiing: ", shop_side_trade.inventory_data)
			#broken due to not alowing dice deck to be sold VVV
			#game_manager.player_resource.getset_dice_deck("set",player_side_inventory.get_node_or_null("Dice Deck/GridContainer").inventory_data)
			pass
#		level_gen.Shop_Type.UPGRADE:
#			shop_name = "Upgrade"
		level_gen.Shop_Type.ITEM:#need specialiced way to give player payed for items + Dice
			print("ITEM Evaluatiing: ", shop_side_trade.inventory_data)
			var combo_inventory = game_manager.player_resource.getset_inventory("get",null) + shop_side_trade.inventory_data
			game_manager.player_resource.getset_inventory("set",combo_inventory)
			
			
	
	

	close_shop()
