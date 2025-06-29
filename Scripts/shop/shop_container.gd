extends GridContainer

var game_manager = GameManager

signal inventory_changed(data:Array[Dictionary])

var inventory_data:Array[Dictionary] = []
@export var trade_side:String





func setup_inventory(input_data:Array[Dictionary],setup_side:String):
	#scrub default dice
	
	inventory_data = input_data.duplicate(true)
	trade_side = setup_side #"deck_inventory"
	#check for player inventory side
	#print("trade side: ", trade_side)
	if trade_side == "player":
		#add coin item
		inventory_data.append({
	"item_code":5,
	"item_name":"ite_pcoi",
	"texture":"res://Sprites/shop/items/player_gold.png",
	"price":0,
	"use_type":1,
	"coin_amount":game_manager.player_resource.gold,
	"long_name":"player coin",
	"description":"allows player to pay for shop items with gold"
	})
	
	generate_grid()
	
#func scrub_default_dice(input_data:Array[Dictionary]):
#	var scrubbed_data:Array[Dictionary]
#	for value in input_data:
#		#scrub all items for default dice and return full item datas for all items
#		if value["item_code"] == 0:
#			scrubbed_data.append(game_manager.dice_lib.get_dice_data(value["item_name"]))
#		else:
#			scrubbed_data.append(value)
#	return scrubbed_data

func setup_deck():
	inventory_data = game_manager.player_resource.getset_dice_deck("get_converted",null).duplicate(true)
	trade_side = "deck"
	generate_grid()

func generate_grid():
	clear_grid()
	var only_one_array = only_one_of_each(inventory_data)
	#print("input data, ", input_data)
	for item in only_one_array:
		#print("item: ", item)
		var next_item = game_manager.item_prefab.instantiate()
		add_child(next_item)
		next_item.setup_item(item,trade_side)
	inventory_changed.emit(inventory_data)
	
func clear_grid():
	for child in get_children():
		child.queue_free()
		
func update_grid():
	for child in get_children():
		child.update_quantity()

func add_item_to_grid(input_data:Dictionary):
	if inventory_data.find(input_data) != -1 && input_data["item_code"]!=5:
		print("Shop sanity FOUND in moving inventory")
		manage_grid(false,input_data)
	else:
		if input_data["item_code"]==5:
			if !get_children().any(func(item): return item.item_data["item_code"] == 5):
				manage_grid(true,input_data)
			else:
				manage_grid(false,input_data)
		else:
			print("Shop sanity did NOT find in moving inventory")
			manage_grid(true,input_data)

func remove_from_grid(item_data:Dictionary):
	if inventory_data.find(item_data) != -1:
		inventory_data.remove_at(inventory_data.find(item_data))
	else:
		print("error item not found in inventory")
	generate_grid()

func manage_grid(is_new:bool,item_data:Dictionary):
	if item_data["item_code"] != 5:
		manage_inventory("add",item_data)
	else:
		var player_coin_in_trade_node
		if get_children().any(func(item): return item.item_data["item_code"] == 5) && !is_new:
			for item_node in get_children():
				if item_node.item_data["item_code"] == 5:
					player_coin_in_trade_node = item_node
					break
			
			player_coin_in_trade_node.item_data["coin_amount"] += item_data["coin_amount"]
			player_coin_in_trade_node.update_quantity()
		else:
			manage_inventory("add",item_data)
	
	if !is_new:
		var item_found:bool = false
		for item in get_children():
			if !item_found:
				if item.item_data == item_data:#check item
					item_found = true
					#inventory_data.append(item_data).
					item.update_quantity()
			else:
				break
	else:
		var next_item:Shop_Item = game_manager.item_prefab.instantiate()
		add_child(next_item)
		#inventory_data.append(item_data)
		next_item.setup_item(item_data,trade_side)
		#inventory_data.append(next_item.item_data)
		
	

func get_inventory():
	return inventory_data
	
func manage_inventory(choice:String,input_data):
	match choice:
		"add":
			if typeof(input_data) == TYPE_DICTIONARY:
#				if input_data["item_name"]=="ite_pcoi":
#					pass
#				else:
					inventory_data.append(input_data)
			else:
				print("error on item data")
		"remove":
			#print("inventory BEFORE Sanity: ", inventory_data)
			if inventory_data.find(input_data) != -1:
				inventory_data.remove_at(inventory_data.find(input_data))
				#print("inventory AFTER Sanity: ", inventory_data)
			elif input_data["item_name"]=="ite_pcoi":
				pass
			else:
				print("error on item data cannot find in inventory")
				
	#generate_grid()
	inventory_changed.emit(inventory_data)

func only_one_of_each(input_array:Array[Dictionary]):
	var output_array:Array[Dictionary] 
	
	for value in input_array:
		#check for default dice
		if value["item_code"] == 0:# for Dice
			#value = game_manager.dice_lib.get_dice_data(value["item_name"])
			if !output_array.any(func(input):return input == value):
				output_array.append(value)
		
		if !output_array.any(func(input):return input == value):
			output_array.append(value)
	
	return output_array

func use_map_item(item_data):
	var main_menu_node = $"../../../../.."
	inventory_data.remove_at(inventory_data.find(item_data))
	match item_data["item_name"]:
		"die_pack":
			# get 3 random dice
			#var pack_dice:Array[Dictionary]
			for i in 3:
				inventory_data.append(game_manager.dice_lib.all_dice.values().pick_random())
		"hea_potion":
			game_manager.player_resource.manage_health("add",game_manager.player_resource.health *.25)
			main_menu_node.setup_stats()
		"ite_forc":
			print("START UPGRADE SEQUENCE!")
			main_menu_node.upgrade_dice_count = 0
			main_menu_node.open_upgrade()
		_:
			print("item is not usable on map/ not coded YET")
			
	#replicate to player
	game_manager.player_resource.inventory = inventory_data.duplicate(true)
	setup_inventory(inventory_data,trade_side)


func use_battle_item(item_data):
	var dice_battle = $"../../../.."

	match item_data["item_name"]:
		"hea_potion":
			game_manager.player_resource.manage_health("add",game_manager.player_resource.max_health *.25)
			dice_battle.update_vitals()
			remove_item(item_data)
		"ite_bomb":
			#print("using Bomb")
			for enemy in dice_battle.get_node_or_null("enemy_layer").get_children():
				enemy.hit_enemy({
					"damage":30,
					"status_conditions":[]
				})
			remove_item(item_data)
		"ite_mims":
			#get enemy attack dice
			var send_dice_data = dice_battle.player_target.get_attack_dice_data()
			send_dice_data["is_temp"] = true
			#add to player hand
			dice_battle.add_dice_to_hand(send_dice_data)
			remove_item(item_data)
		"ite_fatf":
			#bring all dice to hand
			dice_battle.rehand_dice()
			#start fate fragment
			dice_battle.start_fate_fragment(true)
			#dice data in limbo
			dice_battle.cancel_item_button.setup_limbo_item(item_data)
			remove_item(item_data)
		"ite_actu":
			#add action slot
			dice_battle.add_action_up_slot()
			#profit??
			remove_item(item_data)
		"ite_aegc":
			#add status conditon to player
			dice_battle.add_status_conditions(Status_Library.StatusCondition.PROTECT)
			remove_item(item_data)
		"ite_cocc":
			dice_battle.coconut_doubler +=1
			dice_battle.calc_player_attack()
			remove_item(item_data)
		"ite_rage":
			dice_battle.add_status_conditions(Status_Library.StatusCondition.ATKBUFF)
			dice_battle.calc_player_attack() 
			remove_item(item_data)
		"ite_dicf":
			#bring all dice to hand
			dice_battle.rehand_dice()
			#start selection
			dice_battle.start_dictated_fate(true)
			#dice data in limbo
			dice_battle.cancel_item_button.setup_limbo_item(item_data)
			remove_item(item_data)
		"ite_disd":
			dice_battle.player_target.hit_enemy({
					"damage":0,
					"status_conditions":[Status_Library.StatusCondition.DISARM]
				})
			remove_item(item_data)
		"ite_help":
			dice_battle.add_status_conditions(Status_Library.StatusCondition.HEALBUFF)
			dice_battle.calc_player_attack()
			remove_item(item_data)
		"ite_onet":
			dice_battle.player_target.use_armtie()
			remove_item(item_data)
		"ite_rewi":
			#reroll all dice in hand
			dice_battle.rewind()
			remove_item(item_data)
		"ite_ship":
			dice_battle.add_status_conditions(Status_Library.StatusCondition.DEFBUFF)
			dice_battle.calc_player_attack()
			remove_item(item_data)
		"ite_smok":
			dice_battle.add_status_conditions(Status_Library.StatusCondition.SMOKE)
			remove_item(item_data)
		"ite_wead":
			dice_battle.player_target.hit_enemy({
					"damage":0,
					"status_conditions":[Status_Library.StatusCondition.ATKDEBUFF]
				})
			dice_battle.player_target.ui_calc_turn()
			remove_item(item_data)
		"ite_trad":
			if dice_battle.is_trap_battle:
				print("I can disarm this")
				dice_battle.disarm_trap()
				remove_item(item_data)
		"ite_cure":
			dice_battle.cure_negative_effects()
			remove_item(item_data)
		_:
			print("item is not usable on battle/ not coded YET")
			
	setup_inventory(inventory_data,trade_side)
	
func remove_item(item_data):
	inventory_data.remove_at(inventory_data.find(item_data))
	game_manager.player_resource.inventory.remove_at(game_manager.player_resource.inventory.find(item_data))
