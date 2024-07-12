extends Node


var player_resource

func _ready():
	player_resource = load("res://Resources/player_resource.tres")
	player_resource.reset_values()
