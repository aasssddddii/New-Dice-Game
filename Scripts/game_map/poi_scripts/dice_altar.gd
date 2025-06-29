extends Node2D

var game_manager = GameManager

@onready var inventory_grid = $player_inventory/PanelContainer/GridContainer
@onready var dice_layer = $dice_layer

@onready var description = $"circle description"
@onready var submit_button = $Button
@onready var return_gold_ui = $"return gold ui"
@onready var sacrafice_ui = $sacrafice_ui

@export var ui_item_description:ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_grid.setup_inventory(game_manager.player_resource.getset_inventory("get_dice",null),"altar")
	sacrafice_ui.text = "[center]"+var_to_str(game_manager.player_resource.discarded_dice)

func _on_close_button_down():#Close button
	$"../choice_creator".poi_manager()
	queue_free()

func _process(delta):
	if dice_layer.get_children().size() >= 1:
		var total:int
		for die in dice_layer.get_children():
			total += die.dice_data["price"]/1.5
		return_gold_ui.text = "[center]$" + var_to_str(total)
		show_submit(true)
	else:
		return_gold_ui.text = "[center]$0"
		show_submit(false)
		
		
func show_submit(show:bool):
	description.visible = !show
	submit_button.visible = show


func _on_button_button_down():#submit button
	var final_inventory = $player_inventory/PanelContainer/GridContainer.inventory_data
	for die in dice_layer.get_children():
		game_manager.player_resource.gold += die.dice_data["price"]/1.5
		game_manager.player_resource.discarded_dice+=1
		#print("discarded dice: ", game_manager.player_resource.discarded_dice)
		if game_manager.player_resource.discarded_dice >= 10:
			if !game_manager.player_resource.skills_inventory.has(game_manager.item_lib.discard_data):
				#print("GIVE PLAYER DISCARD UPGRADE")
				game_manager.add_skill("disc_upgrade")
	
	game_manager.player_resource.getset_inventory("set",final_inventory+game_manager.player_resource.getset_inventory("get_item",null))
	_on_close_button_down()

