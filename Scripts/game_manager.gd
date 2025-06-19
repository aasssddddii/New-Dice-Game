extends Node



var player_resource
var player_prefab = preload("res://Prefabs/game_map/player.tscn")
@onready var status_lib:Resource = preload("res://Resources/status_library.tres")
var enemy_lib = preload("res://Resources/enemies/enemy_library.tres")
var dice_battle_prefab = preload("res://Scenes/dice_battle.tscn")
var ui_shop_prefab = preload("res://Prefabs/shop/ui_shop.tscn")
var dice_lib = preload("res://Resources/dice_library.tres")
var item_lib = preload("res://Resources/item_library.tres")
var item_prefab = preload("res://Prefabs/shop_item.tscn")
var picture_item_prefab = preload("res://Prefabs/picture_item.tscn")
var ui_battle_summary = preload("res://Prefabs/game_ui/ui_battle_summary.tscn")
var poi_lib = preload("res://Resources/poi_library.tres")
var level_selection_template = preload("res://Prefabs/new_game_map/level_selection_template.tscn")
var discard_event_prefab = preload("res://Prefabs/event/dice_altar.tscn")
var ui_event = preload("res://Prefabs/event/ui_event.tscn")
#player menu
var player_inventory_menu = preload("res://Prefabs/new_game_map/player_inventory_menu.tscn")


var rng = RandomNumberGenerator.new()

func _ready():
	player_resource = load("res://Resources/player_resource.tres")
	player_resource.reset_values()
	# IDEA of how to implement charms
	add_charm("cha_hpup")
	add_charm("cha_shla")
	add_charm("cha_salv")
#	add_charm("cha_shie")
	add_charm("cha_heal")
	add_charm("cha_corn")
	add_charm("cha_medi")
		
#func default_checker(input_data):
#	if dice_lib.all_dice[input_data["item_name"]] == input_data:
#		return true
#	else:
#		return false
	
#LLO 6/18 Finishing adding charm functionality
func add_charm(charm_name:String):
	player_resource.charm_inventory.append(item_lib.get_charm_data(charm_name))
	match charm_name:
		"cha_hpup":
			player_resource.max_health += 20
			player_resource.health += 20
		"cha_atks":
			player_resource.atk_shield += 1
		"cha_shla":
			player_resource.shl_attack +=1
		"cha_salv":
			player_resource.salvage_tool +=1
		"cha_shie":
			player_resource.shield_up +=1
		"cha_heal":
			player_resource.heal_up +=1
		"cha_corn":
			player_resource.cornicopia_draw +=1
		"cha_medi":
			player_resource.meditate +=1
		"cha_gold":
			player_resource.battle_gold +=1
		_:
			print("Charm not setup yet: game_manager.gd")
	
	
	
	
