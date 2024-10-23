extends Resource
class_name Enemy_Library

var enemy_prefab = load("res://Prefabs/enemies/enemy_template.tscn")

var bat_enemy_resource:Resource = preload("res://Resources/enemies/bat.tres")
var wolf_enemy_resource:Resource = preload("res://Resources/enemies/wolf.tres")
var slime_enemy_resource:Resource = preload("res://Resources/enemies/slime.tres")
var snake_enemy_resource:Resource = preload("res://Resources/enemies/snake.tres")
var ice_wolf_enemy_resource:Resource = preload("res://Resources/enemies/ice_wolf.tres")
var wizard_enemy_resource:Resource = preload("res://Resources/enemies/wizard.tres")

#var all_enemies:Dictionary = {
#	"bat":bat_enemy_resource,
#	"wolf":wolf_enemy_resource,
#	"slime":slime_enemy_resource,
#	"snake":snake_enemy_resource,
#	"ice_wolf":ice_wolf_enemy_resource,
#	"wizard":wizard_enemy_resource
#}
var all_enemies:Dictionary = {
	"bat":bat_enemy_resource
}

var enemies_array = all_enemies.values()

func get_enemy_resource(enemy_name:String):
	return all_enemies[enemy_name]
	
func get_random_enemy():
	return enemies_array.pick_random()
