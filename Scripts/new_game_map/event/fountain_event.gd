extends Node2D

var game_manager = GameManager

@onready var drink_result = $drink_result_background
@onready var bathe_result = $bathe_result_background


# Called when the node enters the scene tree for the first time.
func _ready():
	drink_result.visible = false
	bathe_result.visible = false

func _on_drink_button_button_down():
	game_manager.player_resource.health = game_manager.player_resource.max_health
	drink_result.visible = true


func _on_bathe_button_button_down():
	game_manager.player_resource.manage_health("add_max",20)
	bathe_result.visible = true



func _on_drink_result_button_button_down():
	$"../choice_creator".poi_manager()
	queue_free()


func _on_bathe_result_button_button_down():
	$"../choice_creator".poi_manager()
	queue_free()
