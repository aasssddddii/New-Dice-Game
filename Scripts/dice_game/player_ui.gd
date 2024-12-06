extends Node2D

var game_manager = GameManager

@onready var item_inventory = $item_background
@onready var battle_item_grid = $item_background/battle_item_container


func manage_item_inventory(make_visible:bool):
	item_inventory.visible = make_visible
	if make_visible:
		#generate item inventory in grid
		make_item_grid()
		pass

func _on_item_button_button_down():
	manage_item_inventory(true)
	
func _on_item_close_button_down():
	manage_item_inventory(false)
	
func make_item_grid():
	battle_item_grid.setup_inventory(game_manager.player_resource.getset_inventory("get_battle",null),"battle")
	
