extends ColorRect

signal menu_closed


var game_manager = GameManager
#stats text
@onready var health_text = $content/stats/stats_container/health/current_text
@onready var max_health_text = $content/stats/stats_container/health/max_text
@onready var attak_text = $content/stats/stats_container/atk_power/ui_text
@onready var shield_text = $content/stats/stats_container/shield_power/ui_text
@onready var heal_text = $content/stats/stats_container/heal_power/ui_text
@onready var gold_text = $content/stats/stats_container/gold/ui_text
#stats inventory grid
@onready var inventory_grid = $content/stats/PanelContainer/ScrollContainer/GridContainer
#deck grids
@onready var deck_grid = $content/deck/deck_grid/ScrollContainer/GridContainer
@onready var deck_inventory_grid = $content/deck/inventory_grid/ScrollContainer/GridContainer
#charm grid
@onready var charm_grid = $content/charm/PanelContainer/ScrollContainer/GridContainer
#page buttons
@onready var left_arrow = $buttons/left
@onready var right_arrow = $buttons/right

@onready var content_node = $content
#page bodies
@onready var stat_page = $content/stats
@onready var deck_page = $content/deck
@onready var charm_page = $content/charm

var current_stats_page:int




func _ready():
	setup_stats()
	setup_inventory()
	current_stats_page = 1
	change_page()
	page_arrow_checker()

#inventory + stats page
func open_stats():
	setup_stats()
	setup_inventory()
	page_arrow_checker()
func setup_stats():
	health_text.text = var_to_str(game_manager.player_resource.health)
	max_health_text.text = var_to_str(game_manager.player_resource.max_health)
	attak_text.text = var_to_str(game_manager.player_resource.attack)
	shield_text.text = var_to_str(game_manager.player_resource.defend)
	heal_text.text = var_to_str(game_manager.player_resource.heal_power)
	gold_text.text = var_to_str(game_manager.player_resource.gold)
func setup_inventory():
	inventory_grid.setup_inventory(game_manager.player_resource.inventory,"map")
	
#deck + inventory
func open_deck():
	setup_deck()
	setup_deck_inventory()
func setup_deck():
	#setup deck grid.setup_deck()
	deck_grid.setup_deck()
func setup_deck_inventory():
	#setup inventory again
	deck_inventory_grid.setup_inventory(game_manager.player_resource.inventory,"deck_inventory")
	
	
func open_charm():
	charm_grid.setup_inventory(game_manager.player_resource.charm_inventory,"charm")
	
#close stats menu
func _on_close_button_down():
	if game_manager.player_resource.deck_size <= game_manager.player_resource.dice_deck.size():
		#print("calculation: ", game_manager.player_resource.deck_size ," <= ", game_manager.player_resource.current_deck_amount)
		menu_closed.emit()
		queue_free()
	else:
		print("not enough dice in dice deck")
	
#Show Max HP functions
func show_max_health(choice:bool):
	health_text.visible = !choice
	max_health_text.visible = choice
func _on_health_mouse_entered():
	show_max_health(true)
func _on_health_mouse_exited():
	show_max_health(false)

#page managers
func _on_left_button_down():
	current_stats_page -=1
	change_page()
	page_arrow_checker()
func _on_right_button_down():
	current_stats_page +=1
	change_page()
	page_arrow_checker()
func page_arrow_checker():
	match current_stats_page:
		0:
			left_arrow.visible = false
			right_arrow.visible = true
		1:
			left_arrow.visible = true
			right_arrow.visible = true
		2:
			left_arrow.visible = true
			right_arrow.visible = false
		_:
			pass
func change_page():
	#reset stat body
	for child in content_node.get_children():
		child.visible = false
	#show correct one
	match current_stats_page:
		0:
			open_charm()
			charm_page.visible = true
		1:
			open_stats()
			stat_page.visible = true
		2:
			open_deck()
			deck_page.visible = true
		_:
			pass
