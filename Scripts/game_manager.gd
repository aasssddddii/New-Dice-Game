extends Node



var player_resource
var player_prefab = load("res://Prefabs/game_map/player.tscn")
@onready var status_lib:Resource = preload("res://Resources/status_library.tres")
var enemy_lib = preload("res://Resources/enemies/enemy_library.tres")
var dice_battle_prefab = preload("res://Scenes/dice_battle.tscn")


var rng = RandomNumberGenerator.new()

func _ready():
	player_resource = load("res://Resources/player_resource.tres")
	player_resource.reset_values()
