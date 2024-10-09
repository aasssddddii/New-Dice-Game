extends Node2D
class_name map_gen

enum Level_Type{
	MAGIC,
	TECH,
	NATURE,
	ELEMENT
}

var game_manager = GameManager

var current_player

var level_template = load("res://Prefabs/game_map/level_template.tscn")
@onready var level_spawns_node = $level_spawns


func _ready():
	#random spin for flair
	level_spawns_node.rotation_degrees = game_manager.rng.randi_range(-360,360)
	
	#spawns in level paths
	var i:int = 0
	
	for level_spawn in level_spawns_node.get_children():
		var next_level = level_template.instantiate()
		
		level_spawn.add_child(next_level)
		##GIVE Level a Level Type to function
		match i:
			0:
				next_level.current_level_type = Level_Type.MAGIC
			1:
				next_level.current_level_type = Level_Type.TECH
			2:
				next_level.current_level_type = Level_Type.NATURE
			3:
				next_level.current_level_type = Level_Type.ELEMENT
			_:
				print("no level type set")
		next_level.generate_level()
		
		
		i += 1
	spawn_player()
	


func spawn_player():
	current_player = game_manager.player_prefab.instantiate()
	add_child(current_player)
