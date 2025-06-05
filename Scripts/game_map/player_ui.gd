extends Node2D

var game_manager = GameManager

var screen_in_use:bool = false


func _on_player_inventory_button_down():
	#open player inventory(new prefab)
	if !screen_in_use:
		var next_menu = game_manager.player_inventory_menu.instantiate()
		next_menu.menu_closed.connect(reset_in_use)
		#next_menu.position += Vector2(576,324)
		add_child(next_menu)
		screen_in_use = true
	else:
		print("screen in use")

func reset_in_use():
	screen_in_use = false


func _on_settings_button_down():
	#open settings menu(new prefab)
	pass 
