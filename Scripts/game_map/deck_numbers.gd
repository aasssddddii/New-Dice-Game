extends Node2D

var game_manager = GameManager

@onready var min_dice = $min_dice
@onready var current_dice = $current_dice



func _on_grid_container_inventory_changed(data):
	var new_current_size = data.size()
	min_dice.text = var_to_str(game_manager.player_resource.deck_size)
	current_dice.text = var_to_str(new_current_size)
	game_manager.player_resource.current_deck_amount = new_current_size
	color_shifter()

func color_shifter():
	if game_manager.player_resource.deck_size < game_manager.player_resource.current_deck_amount:
		modulate = Color.GREEN
	elif game_manager.player_resource.deck_size == game_manager.player_resource.current_deck_amount:
		modulate = Color.GOLD
	else:
		modulate = Color.RED
