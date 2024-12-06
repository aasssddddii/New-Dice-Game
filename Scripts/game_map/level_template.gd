extends HBoxContainer
class_name level_gen

var game_manager = GameManager

enum POI_Pattern_Type{
	FIGHT,
	EVENT,
	RANDOM,
	SHOP,
	BOSS
}
enum Shop_Type{
	DICE,
	SKILL,
	ITEM,
	COMBO
}



var one_poi_container = load("res://Prefabs/game_map/poi containers/1_poi.tscn")
var two_poi_container = load("res://Prefabs/game_map/poi containers/2_poi.tscn")
var three_poi_container = load("res://Prefabs/game_map/poi containers/3_poi.tscn")


#var level_pattern:Array[POI_Pattern_Type] = [POI_Pattern_Type.FIGHT,POI_Pattern_Type.EVENT,POI_Pattern_Type.FIGHT,POI_Pattern_Type.EVENT,POI_Pattern_Type.FIGHT,POI_Pattern_Type.EVENT,POI_Pattern_Type.FIGHT,POI_Pattern_Type.EVENT,POI_Pattern_Type.SHOP,POI_Pattern_Type.BOSS]
#var level_pattern:Array[POI_Pattern_Type] = [POI_Pattern_Type.FIGHT,POI_Pattern_Type.SHOP,POI_Pattern_Type.FIGHT,POI_Pattern_Type.SHOP,POI_Pattern_Type.FIGHT,POI_Pattern_Type.SHOP,POI_Pattern_Type.FIGHT,POI_Pattern_Type.SHOP,POI_Pattern_Type.BOSS]
#var level_pattern:Array[POI_Pattern_Type] = [POI_Pattern_Type.SHOP,POI_Pattern_Type.SHOP,POI_Pattern_Type.SHOP,POI_Pattern_Type.SHOP,POI_Pattern_Type.SHOP,POI_Pattern_Type.SHOP,POI_Pattern_Type.SHOP,POI_Pattern_Type.SHOP]
var level_pattern:Array[POI_Pattern_Type] = [POI_Pattern_Type.EVENT,POI_Pattern_Type.EVENT,POI_Pattern_Type.EVENT,POI_Pattern_Type.EVENT,POI_Pattern_Type.EVENT,POI_Pattern_Type.EVENT,POI_Pattern_Type.EVENT,POI_Pattern_Type.EVENT]



var last_poi_count:int = 0

var current_level_type#:map_gen.Level_Type

#func _ready():
#	generate_level()


#used to generate level paths
func generate_level():
	var i =0
	for pattern in level_pattern:
		var poi_count = game_manager.rng.randi_range(1,3)
		#print("index: ", i, " value: ",poi_count)
		
		var ref_poi_container
		
		if i == 0 || pattern == POI_Pattern_Type.BOSS:
			poi_count = 1
		
		#matches to rng poi count
		match poi_count:
			1:
				if game_manager.rng.randi_range(1,20)>12 && i != 0 && pattern != POI_Pattern_Type.BOSS:
					ref_poi_container = two_poi_container
					last_poi_count = 2
					#print("ONE poi bumped to TWO")
				else:
					ref_poi_container = one_poi_container
					last_poi_count = 1
			2:
				ref_poi_container = two_poi_container
				last_poi_count = 2
			3:
				if game_manager.rng.randi_range(1,20) > 12 && last_poi_count != 3:
					ref_poi_container = three_poi_container
					last_poi_count = 3
				else:
					ref_poi_container = one_poi_container
					last_poi_count = 1
					#print("faled three poi try")
					
		var next_poi_container = ref_poi_container.instantiate()

		for child in next_poi_container.get_children():
			if child is POI:
				poi_creator(child,pattern,i)
		
		add_child(next_poi_container)
		i += 1

func create_battle_data():
	var output_data:Dictionary
	
	#decide how many enemies
	#decide what enemies (based on level type)
	var enemy_array:Array[Resource]
	for i in 1:#game_manager.rng.randi_range(1,3):
		match current_level_type:
			#uncomment when I have Level Specific Enemies
#			map_gen.Level_Type.MAGIC:
#				pass
#			map_gen.Level_Type.TECH:
#				pass
#			map_gen.Level_Type.NATURE:
#				pass
#			map_gen.Level_Type.ELEMENT:
#				pass
			_:
				enemy_array.append(game_manager.enemy_lib.get_random_enemy())
				pass
		
	#decide on battle rewards
	#calculate gold or dice reward packed scene
	var reward
	if game_manager.rng.randi_range(1,20)<1:#5:
		#calculate gold
		var gold = 0
		for enemy_array_resource in enemy_array:
			gold += enemy_array_resource.reward_gold
		
		reward = gold
		
	else:
		reward = "dice"
	
	output_data = {
		"enemies":enemy_array,
		"reward":reward
	}
	
	
	return output_data

func create_shop():
	var output_data:Dictionary
	var shop_inventory:Array[Dictionary]
	#Shop type selector VVV NEED to ADD COMBO Back when ready
	var next_shop_type = [Shop_Type.DICE,Shop_Type.SKILL,Shop_Type.DICE,Shop_Type.SKILL,Shop_Type.ITEM,Shop_Type.ITEM].pick_random()
	
	match next_shop_type:#Creates Shop Inventory
		Shop_Type.DICE:
			for i in game_manager.rng.randi_range(3,20):#NEED to change to be dependent on how far the player is in the game
				var next_dice = game_manager.dice_lib.all_dice.values().pick_random()
				shop_inventory.append(next_dice)
		Shop_Type.SKILL:#need a way to not generate discard slot when 2 are active
			for item in game_manager.item_lib.all_shop_skills.values():
				shop_inventory.append(item)
#		Shop_Type.UPGRADE:
#			pass
		Shop_Type.ITEM:
			for i in game_manager.rng.randi_range(3,20):#NEED to change to be dependent on how far the player is in the game
				var next_item = game_manager.item_lib.all_items.values().pick_random()
				shop_inventory.append(next_item)
#		Shop_Type.COMBO:
#			pass
	
	output_data = {
		"shop_type":next_shop_type,
		"inventory":shop_inventory
	}
	return output_data

func create_event():
	#var output_data:PackedScene = game_manager.event_lib.dice_altar
	var output_data:PackedScene = game_manager.event_lib.basic_event
	
	
	
	
	return output_data



func poi_creator(input_poi:POI, current_pattern,level_index):
		#
		##I need a way to assign POI data prolly here as a Dict
		#
	var battle_data:Dictionary
	var event_data:PackedScene
	var shop_data:Dictionary
	
	match current_pattern:
		POI_Pattern_Type.FIGHT:#Create Battle Based on current game level
			battle_data = create_battle_data()
		POI_Pattern_Type.EVENT:#create Event
			event_data = create_event()
		POI_Pattern_Type.SHOP:#Maybe make a shop function for this
			shop_data = create_shop()
		POI_Pattern_Type.BOSS:
			battle_data
	
	
	var poi_data:Dictionary = {
		"level_type":current_level_type,
		"pattern_type":current_pattern,
		"level_index":level_index,
		"battle_data":battle_data,#new Dictionary
		"event_data":event_data,#new Dictionary
		"shop_data":shop_data#new Dictionary
	}
	#print("POI Found: ", input_poi.name)
	input_poi.setup_poi(poi_data)
