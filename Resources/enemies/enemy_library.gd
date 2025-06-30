extends Resource
class_name Enemy_Library

var enemy_prefab = load("res://Prefabs/enemies/enemy_template.tscn")
var trap_prefab = load("res://Prefabs/enemies/trap_template.tscn")

#Regular Enemies
var bat_enemy_resource:Resource = preload("res://Resources/enemies/bat.tres")
var wolf_enemy_resource:Resource = preload("res://Resources/enemies/wolf.tres")
var slime_enemy_resource:Resource = preload("res://Resources/enemies/slime.tres")
var fire_slime_enemy_resource:Resource = preload("res://Resources/enemies/fire_slime.tres")
var snake_enemy_resource:Resource = preload("res://Resources/enemies/snake.tres")
var ice_wolf_enemy_resource:Resource = preload("res://Resources/enemies/ice_wolf.tres")
var wizard_enemy_resource:Resource = preload("res://Resources/enemies/wizard.tres")
var ghost_enemy_resource:Resource = preload("res://Resources/enemies/ghost.tres")

#Minibosses (Becomes regular enemy on higer difficulties)
var minotaur_enemy_resource:Resource = preload("res://Resources/enemies/minotaur.tres")

#Bosses (Only show in Boss Battle Tier)
var shark_enemy_resource:Resource = preload("res://Resources/enemies/shark.tres")

#Trap
var trap_enemy_resource:Resource = preload("res://Resources/enemies/trap.tres")

#Sphynx enemy
var sphynx_enemy_resource:Resource = preload("res://Resources/enemies/sphynx.tres")

var all_enemies:Dictionary = {
	#Basic Enemies VVV
	"bat":bat_enemy_resource,
	"wolf":wolf_enemy_resource,
	"slime":slime_enemy_resource,
	"snake":snake_enemy_resource,
	"ice_wolf":ice_wolf_enemy_resource,
	"wizard":wizard_enemy_resource,
	"ghost":ghost_enemy_resource
}
#var all_enemies:Dictionary = {
#	"snake":snake_enemy_resource,
#}
var all_minibosses:Dictionary = {
	"minotaur":minotaur_enemy_resource
}
var all_bosses:Dictionary = {
	"shark":shark_enemy_resource
}

var enemies_array = all_enemies.values()
var miniboss_array = all_minibosses.values()
var bosses_array = all_bosses.values()

func get_enemy_resource(enemy_name:String):
	return all_enemies[enemy_name]
func get_miniboss_resource(enemy_name:String):
	return all_minibosses[enemy_name]
func get_boss_resource(enemy_name:String):
	return all_bosses[enemy_name]
	
func get_random_enemy():
	return enemies_array.pick_random()
	
func get_random_miniboss():
	return miniboss_array.pick_random()
	
func get_random_boss():
	return bosses_array.pick_random()
