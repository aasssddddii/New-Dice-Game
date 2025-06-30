extends Node2D

var game_manager = GameManager

@onready var ui_item_description = $ui_item_desciption 
@onready var inventory_grid = $player_inventory/PanelContainer/GridContainer

@onready var rolloff_title = $Title
@onready var rolloff_body = $ui_body
@onready var rolloff_prompt_parent = $rolloff_requirements

@onready var summary_display = $summary_display
@onready var summary_body = $summary_display/VBoxContainer/ui_body
var rolloff_results
var start_battle_on_exit:bool
var battle_enemies:Array[Resource] =[]
var rolloff_event_data:Dictionary
#Test Rolloff Event Data
#{
#	"title":"",
#	"body":"",
#	"choices":[{
#		"text":"",
#		"required_dice":[],
#		"success_result": Event_Results,
#		"fail_result":Event_Results}}]
#}
func _ready():
	
	setup_rolloff_event(game_manager.poi_lib.moonlit_clearing_event_data)
	

func setup_rolloff_event(input_data:Dictionary):
	inventory_grid.setup_inventory(game_manager.player_resource.getset_dice_deck("get",null)+game_manager.player_resource.getset_inventory("get",null),"rolloff")
	summary_display.visible = false
	rolloff_event_data = input_data
	rolloff_title.text = "[center]" + input_data["title"]
	rolloff_body.text = input_data["body"]
	
	for choice_data in input_data["choices"]:
		var next_choice = game_manager.rolloff_choice_prefab.instantiate()
		rolloff_prompt_parent.add_child(next_choice)
		next_choice.setup_choice(choice_data)
		
func setup_summary(input_text:String,result,enemies):
	summary_body.text = input_text
	summary_display.visible = true
	rolloff_results = result
	battle_enemies = enemy_resource_converter(enemies)


func _on_result_button_button_down():
	event_resolver(rolloff_results)
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
	
func event_resolver(event_result:POI_Library.Event_Results):
	
	match event_result:
		#maybe check before subtracting health to check if player will die to slow down player death until player can read box
		POI_Library.Event_Results.LOSSHPMINOR:
			game_manager.player_resource.manage_health("subtract",game_manager.player_resource.max_health/4)
		POI_Library.Event_Results.LOSSHPMAJOR:
			game_manager.player_resource.manage_health("subtract",game_manager.player_resource.max_health/2)
		POI_Library.Event_Results.STARTBATTLE:
			start_battle_on_exit = true
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

func enemy_resource_converter(enemy_array):
	var send_array:Array[Resource]
	for next_enemy in enemy_array:
		send_array.append(game_manager.enemy_lib.get_enemy_resource(next_enemy))
	return send_array
