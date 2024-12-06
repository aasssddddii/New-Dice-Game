extends Node



var player_resource
var player_prefab = preload("res://Prefabs/game_map/player.tscn")
@onready var status_lib:Resource = preload("res://Resources/status_library.tres")
var enemy_lib = preload("res://Resources/enemies/enemy_library.tres")
var dice_battle_prefab = preload("res://Scenes/dice_battle.tscn")
var ui_shop_prefab = preload("res://Prefabs/shop/ui_shop.tscn")
var dice_lib = preload("res://Resources/dice_library.tres")
var item_lib = preload("res://Resources/item_library.tres")
var event_lib = preload("res://Resources/event_library.tres")
var item_prefab = preload("res://Prefabs/shop_item.tscn")
var picture_item_prefab = preload("res://Prefabs/picture_item.tscn")
var ui_battle_summary = preload("res://Prefabs/game_ui/ui_battle_summary.tscn")
#player menu
var player_inventory_menu = preload("res://Prefabs/game_map/player_inventory_menu.tscn")


var rng = RandomNumberGenerator.new()

func _ready():
	player_resource = load("res://Resources/player_resource.tres")
	player_resource.reset_values()

func default_checker(input_data):
	if dice_lib.all_dice[input_data["item_name"]] == input_data:
		return true
	else:
		return false
