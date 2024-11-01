extends Node2D

var game_manager = GameManager




func _on_player_inventory_button_down():
	#open player inventory(new prefab)
	var next_menu = game_manager.player_inventory_menu.instantiate()
	add_child(next_menu)
	next_menu.open_stats()



func _on_settings_button_down():
	#open settings menu(new prefab)
	pass 
