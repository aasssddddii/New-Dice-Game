extends Sprite2D

var game_manager = GameManager

var current_level_index:int = -1
var current_level_type:map_gen.Level_Type

@onready var player_camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func try_poi(input_poi:POI):
	var poi_data_ref = input_poi.poi_data
	#Need to check for level type
	if poi_data_ref["level_index"] == current_level_index +1:#a valid next poi was clicked
		print("viable poi clicked: ", poi_data_ref)
		move_player(input_poi)
	else:
		print("Player cannot move here yet")
		
	pass # Replace with function body.



func move_player(input_poi:POI):
	var poi_ref_data = input_poi.poi_data
	current_level_index = poi_ref_data["level_index"]
	current_level_type = poi_ref_data["level_type"]
	
	var player_mover = get_tree().create_tween()
	await player_mover.tween_property(self,"position",input_poi.mouse_detector.global_position,1).finished
	
	resolve_poi(poi_ref_data)
	
func resolve_poi(input_data:Dictionary):
	#print("poi input data: ", input_data)
	match input_data["pattern_type"]:
		level_gen.POI_Pattern_Type.FIGHT:
			var next_battle = game_manager.dice_battle_prefab.instantiate()
			player_camera.add_child(next_battle)
			manage_camera("battle")
			next_battle.position = Vector2(-577,-325)
#			next_battle.scale = Vector2(2.23,2.23)
			next_battle.setup_dice_batle(input_data["battle_data"])
			
		level_gen.POI_Pattern_Type.EVENT:
			var next_event = input_data["event_data"].instantiate()
			player_camera.add_child(next_event)
			manage_camera("battle")
			next_event.position = Vector2(-577,-325)
		level_gen.POI_Pattern_Type.SHOP:
			var next_shop = game_manager.ui_shop_prefab.instantiate()
			var next_shop_data = input_data["shop_data"]
			player_camera.add_child(next_shop)
			next_shop.setup_shop(next_shop_data)
			manage_camera("battle")
			next_shop.position = Vector2(-577,-325)
			
			
		level_gen.POI_Pattern_Type.BOSS:
			pass
	
	
func manage_camera(choice:String):
	match choice:
		"map_reset":
			player_camera.zoom = Vector2(.45,.45)
			pass
		"battle":
			player_camera.zoom = Vector2(1,1)
			pass
		
	
	
	
