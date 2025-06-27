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

var player_side_value:int
var shop_side_value:int


func setup_shop(input_data:Dictionary):
	shop_data = input_data
	create_shop()
	setup_player_side()
	update_trade_values()



func create_shop():
	var export_inventory:Array[Dictionary]
	var shop_name:String
	match shop_data["shop_type"]:
		POI_Library.Shop_Type.DICE:
			shop_name = "Dice Shop"
		POI_Library.Shop_Type.SKILL:
			shop_name = "Skill Shop"
#		POI_Library.Shop_Type.UPGRADE:
#			shop_name = "Upgrade"
		POI_Library.Shop_Type.ITEM:
			shop_name = "Item Shop"
		POI_Library.Shop_Type.COMBO:
			shop_name = "Combo Shop"
		POI_Library.Shop_Type.CHARM:
			shop_name = "Charm Shop"
	
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
	#print("SANITY CHECK inventory before coin?: ", inventory_data)
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
			#if item.item_data["item_code"] != 1:
			shop_side_grid_container.manage_inventory("remove",item_data)
		"player_side":
			if item_data["item_name"] == "ite_pcoi":#if its the player coin
				move_side = "player_trade"
				print("move side: ", move_side)
			else:
				move_side = "player_trade"
				player_side_grid_container.manage_inventory("remove",item_data)
		"shop_trade":
			move_side = "shop_side"
			shop_side_trade.manage_inventory("remove",item_data)
		"player_trade":
			if item_data["item_name"] == "ite_pcoi":#if its the player coin
				move_side = "player_side"
				print("move side: ", move_side)
			else:
				move_side = "player_side"
				player_side_trade.manage_inventory("remove",item_data)
			
	item.get_node_or_null("..").update_grid()
	#print("item clicked on ",item.active_trade_side," side moving to ", move_side)

	var need_to_subtract_gold:int
	match move_side:
		"shop_side":
			shop_side_grid_container.add_item_to_grid(item_data)
		"player_side":
			if item_data["item_code"] == 5:
				#calculate how much gold to put back in player inventory
				var gold_to_go_to_player:int
				if shop_side_value < item_data["coin_amount"] && shop_side_value != 0:
					print("SANITY shop_side value: ", shop_side_value)
					gold_to_go_to_player = item_data["coin_amount"]-shop_side_value
					item_data["coin_amount"]-=gold_to_go_to_player
					item.update_quantity()
					
					var sending_coin = {
					"item_code":5,
					"item_name":"ite_pcoi",
					"texture":"res://Sprites/shop/items/player_gold.png",
					"price":0,
					"use_type":1,
					"coin_amount":gold_to_go_to_player,
					"long_name":"player coin",
					"description":"allows player to pay for shop items with gold"
					}
					player_side_grid_container.add_item_to_grid(sending_coin)
				else:
					#RETURN ALL GOLD TO PLAYER HERE and queue free gold item
					player_side_grid_container.add_item_to_grid(item_data)
					player_side_trade.manage_inventory("remove",item_data)
					item.queue_free()
					pass
					
			else:
				player_side_grid_container.add_item_to_grid(item_data)
		"shop_trade":
			shop_side_trade.add_item_to_grid(item_data)
		"player_trade":
			#maybe do something here for player coin
			if item_data["item_code"] == 5:
				#Calculate the gold neded from the trade side
				var player_trade_gold_item
				for item_node in player_side_trade.get_children():
					if item_node.item_data["item_code"]==5:
						player_trade_gold_item = item_node
						
				var gold_in_player_side:int
				if player_trade_gold_item != null:
					gold_in_player_side = player_trade_gold_item.item_data["coin_amount"]
					
				print("player side value: ",player_side_value )
				print("SANITY is coin amount bigger: ",item_data["coin_amount"] - shop_side_value - gold_in_player_side >= 0 && gold_in_player_side < shop_side_value - player_side_value && item_data["coin_amount"] >= shop_side_value)
				if item_data["coin_amount"] - shop_side_value - gold_in_player_side >= 0 && gold_in_player_side < shop_side_value - player_side_value && item_data["coin_amount"] >= shop_side_value:
					need_to_subtract_gold = shop_side_value - gold_in_player_side - player_side_value
					
					var sending_coin:Dictionary = {
						"item_code":5,
						"item_name":"ite_pcoi",
						"texture":"res://Sprites/shop/items/player_gold.png",
						"price":0,
						"use_type":1,
						"coin_amount":need_to_subtract_gold,
						"long_name":"player coin",
						"description":"allows player to pay for shop items with gold"
						}
					if shop_side_value > 0 && gold_in_player_side < shop_side_value - player_side_value:
						player_side_trade.add_item_to_grid(sending_coin)
				elif (item_data["coin_amount"] < shop_side_value && player_side_value <=0) || gold_in_player_side + item_data["coin_amount"] < shop_side_value:
					need_to_subtract_gold = item_data["coin_amount"]
					
					var sending_coin:Dictionary = {
						"item_code":5,
						"item_name":"ite_pcoi",
						"texture":"res://Sprites/shop/items/player_gold.png",
						"price":0,
						"use_type":1,
						"coin_amount":need_to_subtract_gold,
						"long_name":"player coin",
						"description":"allows player to pay for shop items with gold"
						}
					#if gold_in_player_side + item_data["coin_amount"] < shop_side_value:
					player_side_trade.add_item_to_grid(sending_coin)
			else:
				player_side_trade.add_item_to_grid(item_data)
			
			if need_to_subtract_gold > 0:
				item_data["coin_amount"] -= need_to_subtract_gold
				item.update_quantity()
				
				
	update_trade_values()
			
	
func update_trade_values():
	player_side_value=0
	shop_side_value=0
	#calculate player side
	print("player trade inventory: " ,player_side_trade.inventory_data)
	for item in player_side_trade.inventory_data:
		player_side_value += item["price"]/2
		if item["item_code"] == 5:
			player_side_value += item["coin_amount"]
		
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
	$"../choice_creator".poi_manager()
	queue_free()

func _on_close_button_down():
	close_shop()


func _on_button_button_down():#SUBMIT button
	for purchased_item in shop_side_trade.inventory_data:
		match purchased_item["item_code"]:
			0,2:#dice,items
				game_manager.player_resource.getset_inventory("add",purchased_item)
			1:#skills
				game_manager.add_skill(purchased_item["item_name"])
			4:#charms
				game_manager.add_charm(purchased_item["item_name"])
		
	var player_shop_grid = get_node_or_null("player_side/Inventory/GridContainer")
	var player_shop_inventory = player_shop_grid.inventory_data
	var inventory_index:int
	for item in player_shop_inventory:
		if item["item_code"] == 5:
			game_manager.player_resource.gold = item["coin_amount"]
			#delete gold item from inventory here VVV
			player_shop_inventory.remove_at(inventory_index)
			inventory_index-=1
	close_shop()
