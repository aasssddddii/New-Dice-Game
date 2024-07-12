extends Resource
class_name Enemy_Library

var enemy_prefab = load("res://Prefabs/enemies/enemy_template.tscn")

var bat_enemy_resource:Resource = preload("res://Resources/enemies/bat.tres")
var wolf_enemy_resource:Resource = preload("res://Resources/enemies/wolf.tres")
var slime_enemy_resource:Resource = preload("res://Resources/enemies/slime.tres")

var all_enemies:Dictionary = {
	"bat":bat_enemy_resource,
	"wolf":wolf_enemy_resource,
	"slime":slime_enemy_resource
}


func get_enemy_resource(enemy_name:String):
	return all_enemies[enemy_name]
	
	
