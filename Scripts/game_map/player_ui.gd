extends Node2D

var game_manager = GameManager

@onready var choice_creator = $"../choice_creator"


func _on_player_inventory_button_down():
	#open player inventory(new prefab)
	if !game_manager.screen_in_use:
		var next_menu = game_manager.player_inventory_menu.instantiate()
		next_menu.menu_closed.connect(reset_in_use)
		#next_menu.position += Vector2(576,324)
		add_child(next_menu)
		game_manager.screen_in_use = true
	else:
		print("screen in use")

func reset_in_use():
	game_manager.screen_in_use = false


func _on_settings_button_down():
	#open settings menu(new prefab)
	pass 

func setup_wish_results(wish_codes:Array[int]):
	var picked_wish_code = wish_codes.pick_random()
	print("showing results for wish code: ", picked_wish_code)
	var wish_result_text:String = game_manager.poi_lib.wish_results[picked_wish_code].pick_random()
	match picked_wish_code:
		0:#attack up
			game_manager.player_resource.attack += 20
		1:#defend up
			game_manager.player_resource.defend += 20
		2:#heal power up
			game_manager.player_resource.heal_power += 20
		3:#free item
			game_manager.player_resource.getset_inventory("add", game_manager.item_lib.all_items.values().pick_random())
		4:#free charm
			game_manager.player_resource.getset_inventory("add", game_manager.item_lib.all_charms.values().pick_random())
		5:#free upgrade
			game_manager.player_resource.getset_inventory("add", game_manager.item_lib.all_shop_skills.values().pick_random())
		6:#free dice
			game_manager.player_resource.getset_inventory("add", game_manager.dice_lib.all_dice.values().pick_random())
		7:#max hp up
			game_manager.player_resource.max_health += 100
			game_manager.player_resource.health += 100
		8:#free gold
			game_manager.player_resource.gold += 1000
			
	choice_creator.show_wish_results(wish_result_text,true)
