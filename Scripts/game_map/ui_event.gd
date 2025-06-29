extends Node2D

var game_manager = GameManager


var button_prefab = preload("res://Prefabs/event/button.tscn")

var event_data:Dictionary
var battle_enemies:Array[Resource] =[]

var start_battle_on_exit:bool = false
#func _ready():
#	setup_event(game_manager.poi_lib.test_event_data)

# Called when the node enters the scene tree for the first time.
func setup_event(input_data:Dictionary):
	var ui_title = $Title
	var ui_body = $ui_body
	var choice_parent = $options_parent
	
	event_data = input_data
	
	ui_title.text = event_data["title"]
	ui_body.text = event_data["body"]
	var option_text_array = event_data["option_text"]
	var option_index:int = 0
	for option in event_data["options"]:
		var next_option = button_prefab.instantiate()
		var keys_array = option.keys()
		var values_array = option.values()
		next_option.text = keys_array[0]
		
		next_option.button_down.connect(event_resolver.bind(values_array[0],option_text_array[option_index]))
		choice_parent.add_child(next_option)
		option_index += 1
	
	
func event_resolver(event_result:POI_Library.Event_Results, result_text:String):
	
	setup_result(result_text)
	print("test: ", event_result, " text: ", result_text)
	match event_result:
		#maybe check before subtracting health to check if player will die to slow down player death until player can read box
		POI_Library.Event_Results.LOSSHPMINOR:
			game_manager.player_resource.manage_health("subtract",game_manager.player_resource.max_health/4)
		POI_Library.Event_Results.LOSSHPMAJOR:
			game_manager.player_resource.manage_health("subtract",game_manager.player_resource.max_health/2)
		POI_Library.Event_Results.STARTBATTLE:
			start_battle_on_exit = true
			battle_enemies = enemy_resource_converter(event_data["enemies"])
		POI_Library.Event_Results.STARTTRAP:
			start_battle_on_exit = true
			battle_enemies.append(game_manager.enemy_lib.trap_enemy_resource)
		POI_Library.Event_Results.ADDHPMINOR:
			game_manager.player_resource.manage_health("add",game_manager.player_resource.max_health/4)
		POI_Library.Event_Results.ADDHPMAJOR:
			game_manager.player_resource.manage_health("add",game_manager.player_resource.max_health/2)
		POI_Library.Event_Results.ADDDICE:
			game_manager.player_resource.getset_inventory("add",game_manager.dice_lib.all_dice.values().pick_random())
		POI_Library.Event_Results.ADDITEM:
			game_manager.player_resource.getset_inventory("add",game_manager.item_lib.all_items.values().pick_random())
		POI_Library.Event_Results.NOTHING:
			pass
		
		
	
		
		
		
		
		
func setup_result(result_text:String):
	var result_bg = $result_background
	var ui_result_body = $result_background/VBoxContainer/ui_body
	ui_result_body.text = result_text
	result_bg.visible = true
	

func enemy_resource_converter(enemy_array):
	var send_array:Array[Resource]
	for next_enemy in enemy_array:
		send_array.append(game_manager.enemy_lib.get_enemy_resource(next_enemy))
	return send_array
	

func _on_button_button_down():
	if start_battle_on_exit:
		#start dice battle
		var next_dice_battle = game_manager.dice_battle_prefab.instantiate()
		get_parent().add_child(next_dice_battle)
		if battle_enemies == [game_manager.enemy_lib.trap_enemy_resource]:
			next_dice_battle.setup_dice_batle({
				"enemies":battle_enemies,
				"reward":5#Hard coded for Trap disarm reward for simplicity
			})
			queue_free()
		else:
			var reward:String = "gold"
			if game_manager.rng.randi_range(1,20)>16:
				reward = "dice"
			next_dice_battle.setup_dice_batle({
				"enemies":battle_enemies,
				"reward":reward
			})
			queue_free()
	else:
		$"../choice_creator".poi_manager()
		queue_free()
