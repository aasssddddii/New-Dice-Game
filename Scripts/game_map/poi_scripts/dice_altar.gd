extends Node2D

var game_manager = GameManager

@onready var inventory_grid = $player_inventory/PanelContainer/GridContainer
@onready var dice_layer = $dice_layer

@onready var description = $"circle description"
@onready var submit_button = $Button

@export var ui_item_description:ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_grid.setup_inventory(game_manager.player_resource.getset_inventory("get_dice",null),"altar")
	pass # Replace with function body.

func _on_close_button_down():#Close button
	$"../..".manage_camera("map_reset")
	queue_free()

func _process(delta):
	if dice_layer.get_children().size() >= 1:
		show_submit(true)
	else:
		show_submit(false)
		
		
func show_submit(show:bool):
	description.visible = !show
	submit_button.visible = show


func _on_button_button_down():#submit button
	var final_inventory = $player_inventory/PanelContainer/GridContainer.inventory_data
	
	game_manager.player_resource.getset_inventory("set",final_inventory+game_manager.player_resource.getset_inventory("get_item",null))
	_on_close_button_down()

