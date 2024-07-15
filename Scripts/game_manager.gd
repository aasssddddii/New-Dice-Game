extends Node


var player_resource
@onready var status_lib:Resource = preload("res://Resources/status_library.tres")

func _ready():
	player_resource = load("res://Resources/player_resource.tres")
	player_resource.reset_values()
