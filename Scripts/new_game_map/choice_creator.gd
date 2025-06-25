extends HBoxContainer

enum POI_PHASE{
	BATTLE,
	LONG_BATTLE,
	SPECIAL,
	MINIBOSS,
	BOSS,
	REWARD,
	TEST
}

var gamemanager = GameManager
var poi_lib = gamemanager.poi_lib

var poi_rotation:Array[POI_PHASE] = [
	POI_PHASE.BATTLE,
	POI_PHASE.SPECIAL,
	POI_PHASE.BATTLE,
	POI_PHASE.MINIBOSS,
	POI_PHASE.SPECIAL,
	POI_PHASE.BATTLE,
	POI_PHASE.MINIBOSS,
	POI_PHASE.LONG_BATTLE,
	POI_PHASE.SPECIAL,
	POI_PHASE.BOSS
	]
#var poi_rotation:Array[POI_PHASE] = [POI_PHASE.TEST]#for testing trap battles
var current_poi_phase:POI_PHASE
var current_poi_index:int =1#Testing
var battle_count_in_current_phase:int
var battle_count_max_in_phase:int

var special_stack:Array[POI_Library.Event_Type]
# Called when the node enters the scene tree for the first time.
func _ready():#This needs to be moved to a different node soon
	
	poi_manager()


func clear_selection():
	for child in get_children():
		child.queue_free()

func poi_manager():
	current_poi_phase = poi_rotation[current_poi_index]
	match current_poi_phase:
		POI_PHASE.BATTLE:
			if battle_count_in_current_phase == 0:
				battle_count_max_in_phase = gamemanager.rng.randi_range(2,3)
				battle_count_in_current_phase += 1
			elif battle_count_in_current_phase >= battle_count_max_in_phase:
				current_poi_index += 1
				battle_count_in_current_phase = 0
			else:
				battle_count_in_current_phase += 1
					
			#decide how many choices players will get
			var choice_amount = gamemanager.rng.randi_range(1,3) 
			
			#spawn coresponding choices
			for i in choice_amount:
				#decide pois
				var current_poi = poi_lib.battle_poi
				#here is where I spawn
				var next_level = gamemanager.level_selection_template.instantiate()
				#setup selection buttons
				var final_poi = setup_poi(current_poi)
				#print(final_poi)
				next_level.create_selection(final_poi)
				add_child(next_level)
		POI_PHASE.LONG_BATTLE:
			if battle_count_in_current_phase == 0:
				battle_count_max_in_phase = gamemanager.rng.randi_range(3,4)
				battle_count_in_current_phase += 1
			elif battle_count_in_current_phase >= battle_count_max_in_phase:
				current_poi_index += 1
				battle_count_in_current_phase = 0
			else:
				battle_count_in_current_phase += 1
					
			#decide how many choices players will get
			var choice_amount = gamemanager.rng.randi_range(1,3) 
			
			#spawn coresponding choices
			for i in choice_amount:
				#decide pois
				var current_poi = poi_lib.battle_poi
				#here is where I spawn
				var next_level = gamemanager.level_selection_template.instantiate()
				#setup selection buttons
				var final_poi = setup_poi(current_poi)
				#print(final_poi)
				next_level.create_selection(final_poi)
				add_child(next_level)
		POI_PHASE.SPECIAL:
			var choice_amount = gamemanager.rng.randi_range(1,3) 
			var shop_spawned:bool = false
			var current_poi
			
			special_stack.clear()
			current_poi_index += 1
			
			#spawn coresponding choices
			for i in choice_amount:
				#decide pois
				if shop_spawned:
					current_poi = poi_lib.event_poi
				else:
					if gamemanager.rng.randi_range(1,20) < 21:#12: #commented out for testing
						current_poi = poi_lib.shop_poi
						shop_spawned = true
					else:
						current_poi = poi_lib.event_poi
				
				
				
				#here is where I spawn
				var next_level = gamemanager.level_selection_template.instantiate()
				#setup selection buttons
				var final_poi = setup_poi(current_poi)
				#print(final_poi)
				next_level.create_selection(final_poi)
				add_child(next_level)
		POI_PHASE.MINIBOSS:
			current_poi_index += 1
			var current_poi = poi_lib.miniboss_poi
			#here is where I spawn
			var next_level = gamemanager.level_selection_template.instantiate()
			#setup selection buttons
			var final_poi = setup_poi(current_poi)
			#print(final_poi)
			next_level.create_selection(final_poi)
			add_child(next_level)
		POI_PHASE.BOSS:
			current_poi_index = 0
			var current_poi = poi_lib.boss_poi
			#here is where I spawn
			var next_level = gamemanager.level_selection_template.instantiate()
			#setup selection buttons
			var final_poi = setup_poi(current_poi)
			#print(final_poi)
			next_level.create_selection(final_poi)
			add_child(next_level)
		POI_PHASE.REWARD:
			pass
		POI_PHASE.TEST:
			var current_poi = poi_lib.test_poi
			#here is where I spawn
			var next_level = gamemanager.level_selection_template.instantiate()
			#setup selection buttons
			var final_poi = setup_poi(current_poi)
			#print(final_poi)
			next_level.create_selection(final_poi)
			add_child(next_level)

func setup_poi(input_data):
	var output_data:Dictionary = input_data.duplicate()
	match input_data["poi_code"]:
		0:#BATTLE
			#Generate enemies
			var enemies:Array[Resource]
			
			for i in gamemanager.rng.randi_range(1,1):#(1,3):
				enemies.append(gamemanager.enemy_lib.get_random_enemy())
			#give selection image
			var send_img = ""
			if enemies.size() > 2:
				send_img = "res://Sprites/level_selector_assets/battle level 2.png"
			else:
				send_img = "res://Sprites/level_selector_assets/battle level 1.png"
			#set reward
			var reward = ""
			if gamemanager.rng.randi_range(1,20)>0:#>16: #commented for testing
				reward = "dice"
			else:
				var reward_count:int
				for next_enemy in enemies:
					reward_count += gamemanager.enemy_lib.get_enemy_resource(next_enemy.enemy_name).reward_gold
				reward = reward_count
				
			output_data["img_selector"] = send_img
			output_data["enemies"] = enemies
			output_data["reward"] = reward
		1:#SHOP
#			{
#			"poi_code":1,
#			"img_selector":"",
#			"shop_type":Shop_Type.DICE,
#			"inventory":[]
#			}
			#Hard Coded SHop type need to change to dynamic VVV
			output_data["shop_type"] = gamemanager.poi_lib.Shop_Type.SKILL
			
			
			var input_inventory = create_shop(output_data["shop_type"])
			output_data["inventory"] = input_inventory
			print("setup poi inventory: ", input_inventory )
			
			#chage to be based on shop type
			output_data["img_selector"] = "res://Sprites/level_selector_assets/dice_shop.png"
		2:#Event
		#{
		#	"poi_code":2,
		#	"img_selector":"",
		#	"event_type":Event Type,
		#	"event_data": #array or Dict of event information
		#}
			#Pick Event Type
			var current_event_type:POI_Library.Event_Type = gamemanager.poi_lib.event_type_array.pick_random()
			
			#output_data["event_type"] = current_event_type #commented out for testing
			output_data["event_type"] = gamemanager.poi_lib.Event_Type.BASIC
			#Display chosen event type
			match output_data["event_type"]:
				gamemanager.poi_lib.Event_Type.BASIC:
					output_data["img_selector"] = "res://Sprites/level_selector_assets/Event.png"
					#output_data["event_data"] = gamemanager.poi_lib.basic_event_array.pick_random()#  commented out for testing
					output_data["event_data"] = gamemanager.poi_lib.test_event_data
				gamemanager.poi_lib.Event_Type.DISCARD:
					if special_stack.any(func(checker): return checker == POI_Library.Event_Type.DISCARD):
						output_data["img_selector"] = "res://Sprites/level_selector_assets/Event.png"
						output_data["event_data"] = gamemanager.poi_lib.basic_event_array.pick_random()
						output_data["event_type"] = POI_Library.Event_Type.BASIC
						current_event_type = gamemanager.poi_lib.Event_Type.BASIC
					else:
						output_data["img_selector"] = "res://Sprites/level_selector_assets/discard altar.png"
						output_data["event_data"] = {}
			
			special_stack.append(current_event_type)
		3:#Miniboss
			var enemies:Array[Resource]
			enemies.append(gamemanager.enemy_lib.get_random_miniboss())
			
			output_data["img_selector"] = "res://Sprites/level_selector_assets/Miniboss.png"
			output_data["enemies"] = enemies
			
			var reward = ""
			if gamemanager.rng.randi_range(1,20)>10:
				reward = "dice"
			else:
				var reward_count:int
				for next_enemy in output_data["enemies"]:
					reward_count += gamemanager.enemy_lib.get_miniboss_resource(next_enemy.enemy_name).reward_gold
				reward = reward_count
			output_data["reward"] = reward
		4:#Boss
			var enemies:Array[Resource]
			enemies.append(gamemanager.enemy_lib.get_random_boss())
			
			output_data["img_selector"] = "res://Sprites/level_selector_assets/Boss.png"
			output_data["enemies"] = enemies
			
			var reward = ""
			if gamemanager.rng.randi_range(1,20)>10:
				reward = "dice"
			else:
				var reward_count:int
				for next_enemy in output_data["enemies"]:
					reward_count += gamemanager.enemy_lib.get_boss_resource(next_enemy.enemy_name).reward_gold
				reward = reward_count
			output_data["reward"] = reward
		5:#testing trap
			var enemies:Array[Resource]
			enemies.append(gamemanager.enemy_lib.trap_enemy_resource)
			
			output_data["img_selector"] = "res://icon.svg"
			output_data["enemies"] = enemies
			
			output_data["reward"] = "gold"
		_:
			print("error on POI setup | choice_creator.gd")
			
			
	return output_data

func create_shop(shop_type:POI_Library.Shop_Type):
	var shop_inventory:Array[Dictionary]
	match shop_type:#Creates Shop Inventory
		gamemanager.poi_lib.Shop_Type.DICE:
			for i in gamemanager.rng.randi_range(3,20):#NEED to change to be dependent on how far the player is in the game
				var next_dice = gamemanager.dice_lib.all_dice.values().pick_random()
				shop_inventory.append(next_dice)
		gamemanager.poi_lib.Shop_Type.SKILL:
			#select how many skills go into shop maybe 3 to 10 for dice skills and 1 to 3 skill upgrades
			for i in gamemanager.rng.randi_range(3,10):
				shop_inventory.append(gamemanager.item_lib.all_basic_skills.values().pick_random())
			for i in gamemanager.rng.randi_range(3,3):#(1,3):
				var available_skills = gamemanager.item_lib.all_skill_upgrades.values().duplicate(true)
				var picked_skill_upgrade = available_skills.pick_random()
				while (gamemanager.player_resource.skills_inventory.has(picked_skill_upgrade) || shop_inventory.has(picked_skill_upgrade)) && available_skills != []:
					available_skills.remove_at(available_skills.find(picked_skill_upgrade))
					print("removing skill: ", picked_skill_upgrade, " skills left after removal: ", available_skills)
					picked_skill_upgrade = available_skills.pick_random()
				if picked_skill_upgrade != null:
					shop_inventory.append(picked_skill_upgrade)
		gamemanager.poi_lib.Shop_Type.ITEM:
			for i in gamemanager.rng.randi_range(3,20):#NEED to change to be dependent on how far the player is in the game
				var next_item = gamemanager.item_lib.all_items.values().pick_random()
				shop_inventory.append(next_item)
#		Shop_Type.COMBO:
#			pass
	
	#print("next shop inventory: ", shop_inventory)
	return shop_inventory.duplicate()

