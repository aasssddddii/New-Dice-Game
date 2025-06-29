extends Node2D

var game_manager = GameManager

@onready var ui_item_description = $ui_item_desciption 
@onready var inventory_grid = $player_inventory/PanelContainer/GridContainer

@onready var rolloff_title = $Title
@onready var rolloff_body = $ui_body
@onready var rolloff_prompt_parent = $rolloff_requirements
# Called when the node enters the scene tree for the first time.
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
	inventory_grid.setup_inventory(game_manager.player_resource.getset_dice_deck("get",null)+game_manager.player_resource.getset_inventory("get",null),"rolloff")
	setup_rolloff_event(game_manager.poi_lib.test_rolloff_event_data)
	
	pass # Replace with function body.

func setup_rolloff_event(rolloff_event_data:Dictionary):
	
	rolloff_title.text = "[center]"+rolloff_event_data["title"]
	rolloff_body.text = rolloff_event_data["body"]
	
	for choice_data in rolloff_event_data["choices"]:
		var next_choice = game_manager.rolloff_choice_prefab.instantiate()
		rolloff_prompt_parent.add_child(next_choice)
		next_choice.setup_choice(choice_data)
	pass
