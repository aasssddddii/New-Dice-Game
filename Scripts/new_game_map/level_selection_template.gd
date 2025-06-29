extends TextureButton

var gamemanager = GameManager
var poi_lib = gamemanager.poi_lib

var poi_data:Dictionary


func create_selection(input_data):
	#save poi_data to this instance
	poi_data = input_data
	setup_poi()
	

func setup_poi():
	texture_normal = load(poi_data["img_selector"])



func _on_button_down():
	var grandparent = $"../.."
	match poi_data["poi_code"]:
		0:
			#start Dice battle
			var next_dice_battle = gamemanager.dice_battle_prefab.instantiate()
			grandparent.add_child(next_dice_battle)
			next_dice_battle.setup_dice_batle(poi_data)
		1:
			var next_shop = gamemanager.ui_shop_prefab.instantiate()
			grandparent.add_child(next_shop)
			next_shop.setup_shop(poi_data)
		2:
			match poi_data["event_type"]:
				POI_Library.Event_Type.BASIC:
					var next_event = gamemanager.ui_event.instantiate()
					next_event.setup_event(poi_data["event_data"])
					grandparent.add_child(next_event)
				POI_Library.Event_Type.DISCARD:
					var next_event = gamemanager.discard_event_prefab.instantiate()
					grandparent.add_child(next_event)
				POI_Library.Event_Type.UPGRADE:
					var next_event = gamemanager.upgrade_event_prefab.instantiate()
					grandparent.add_child(next_event)
				POI_Library.Event_Type.FOUNTAIN:
					var next_event = gamemanager.fountain_event_prefab.instantiate()
					grandparent.add_child(next_event)
				POI_Library.Event_Type.RIDDLE:
					var next_event = gamemanager.riddle_event_prefab.instantiate()
					grandparent.add_child(next_event)
					next_event.setup_riddle(gamemanager.riddle_lib.riddles.pick_random())
				POI_Library.Event_Type.WELL:
					var next_event = gamemanager.well_event_prefab.instantiate()
					grandparent.add_child(next_event)
				POI_Library.Event_Type.ROLLOFF:
					var next_event = gamemanager.rolloff_event_prefab.instantiate()
					grandparent.add_child(next_event)
				_:
					print("you forgot to add that event")
		3,4:
			var next_dice_battle = gamemanager.dice_battle_prefab.instantiate()
			grandparent.add_child(next_dice_battle)
			next_dice_battle.setup_dice_batle(poi_data)
		5:
			var next_dice_battle = gamemanager.dice_battle_prefab.instantiate()
			grandparent.add_child(next_dice_battle)
			next_dice_battle.setup_dice_batle(poi_data)
			
	get_parent().clear_selection()
	
