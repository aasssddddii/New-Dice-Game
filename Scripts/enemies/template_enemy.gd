extends TextureButton
class_name Enemy

var game_manager = GameManager
var current_enemy_resource:Resource
var status_lib = Status_Library
var attack_data:Dictionary
@onready var ui_turns = $ui_turns
var enemy_ui_turn = load("res://Prefabs/game_ui/enemy_turn_ui.tscn")
var attack_pattern:Array[enemy_resource.TurnActions]

var current_player_damage:int
var enemy_heal:int
var heal_calc

var status_conditions:Array[Status_Library.StatusCondition]
var status_timeouts:Array[int]
var spawned_statuses:Array[Status_Library.StatusCondition]

@onready var status_grid = $status_conditions
#DISPLAY TURN
@onready var calc_ui_shield = $ui_calc/ui_shield
@onready var calc_ui_heal = $ui_calc/ui_health
#UI Current
@onready var ui_health = $ui_current/ui_health
@onready var ui_shield = $ui_current/ui_shield


func setup_enemy(resource:Resource):
	current_enemy_resource = resource
	name = current_enemy_resource.enemy_name
	texture_normal = current_enemy_resource.main_texture
	ui_health.text = var_to_str(current_enemy_resource.health)
	
	
	global_position -= Vector2(64,64)
	setup_next_attack()
	#print("enemy now:", current_enemy_resource.enemy_name)


#player_attack = {
#	"damage":int,
#	"reflect":int,
#	"shield":int,
#	"heal":int,
#	"gold":int,
#	"status_conditions":Array,
#	"elements":Array,
#	"element_damage":Array
#	}
func hit_enemy(attack_data:Dictionary):
	print("hitting enemy- ", name, " with attack: ", attack_data)
	
	
	
	if !attack_data["status_conditions"].is_empty():
		for status in attack_data["status_conditions"]:
			add_status_conditions(status)
	
	


#func update_health():
#	pass

func setup_next_attack():
	attack_pattern.clear()
	reset_ui_turn()
	
	for attack_number in current_enemy_resource.attacks:
		attack_pattern.append(current_enemy_resource.possible_turn_actions.pick_random())
	#print(name," attack pattern: ", attack_pattern)
	ui_calc_turn()
	display_turn_actions(attack_pattern)


func display_turn_actions(attack_pattern:Array[enemy_resource.TurnActions]):
	for turn in attack_pattern:
		var next_turn_ui = enemy_ui_turn.instantiate()
		match turn:
			enemy_resource.TurnActions.ATTACK:
				next_turn_ui.setup_ui_turn(load("res://Sprites/Dice/one attack face.png"))
			enemy_resource.TurnActions.DEFEND:
				next_turn_ui.setup_ui_turn(load("res://Sprites/Dice/defend dice.png"))
			enemy_resource.TurnActions.NONE:
				next_turn_ui.setup_ui_turn(load("res://Sprites/Dice/blank dice template.png"))
				
		ui_turns.add_child(next_turn_ui)

func reset_ui_turn():
	for turn_display in ui_turns.get_children():
		turn_display.queue_free()

func ui_calc_turn():
	var calc_heal:int
	var calc_shield:int
	heal_calc = 0
	for attack in attack_pattern:
		match attack:
			enemy_resource.TurnActions.ATTACK:
				pass
			enemy_resource.TurnActions.DEFEND:
				calc_shield += current_enemy_resource.defend
			enemy_resource.TurnActions.NONE:
				pass
	
	
	if calc_shield >0:
		calc_ui_shield.visible = true
		calc_ui_shield.text ="+"+var_to_str(calc_shield)
	else:
		calc_ui_shield.visible = false
	heal_calc = enemy_heal - current_player_damage
	if heal_calc > 0 :
		calc_ui_heal.visible = true
		calc_ui_heal.text ="+"+var_to_str(heal_calc)
	elif heal_calc < 0 :
		calc_ui_heal.visible = true
		calc_ui_heal.text = var_to_str(heal_calc)
	else:
		calc_ui_heal.visible = false
	print(name," heal calc: ", heal_calc)

func show_arrow(choice:bool):
	var arrow = $target_arrow
	if choice:
		arrow.visible = true
	else:
		arrow.visible = false

func _on_button_down():
	$"../..".update_player_target(self)
	pass # Replace with function body.

func manage_current_player_dmg(choice:String,value):
	match choice:
		"reset":
			current_player_damage = 0
		"set":
			current_player_damage = value
	ui_calc_turn()

func manage_enemy_heal(choice:String,value):
	match choice:
		"reset":
			enemy_heal = 0
		"set":
			enemy_heal = value
	ui_calc_turn()
	

func add_status_conditions(value):
	if typeof(value) != TYPE_ARRAY:
		var status_ref = game_manager.status_lib.get_status_data(value)
		status_conditions.append(value)
		status_timeouts.append(status_ref["turns"])
		
		#print("statuses is now: ",  status_conditions)
		#print("status timeout is now: ",  status_timeouts)
		
		if spawned_statuses.find(value) == -1:
			spawned_statuses.append(value)
			var next_ui_status = game_manager.status_lib.status_prefab.instantiate()
			status_grid.add_child(next_ui_status)
			next_ui_status.setup_status(status_ref)
			
			
			
func do_status_effects():
	var condition_index:int
	for status in status_conditions:
		#do status stuff
		match status:
			Status_Library.StatusCondition.BLEED:
				pass
			Status_Library.StatusCondition.REFLECT:
				pass
			Status_Library.StatusCondition.DISARM:
				pass
			Status_Library.StatusCondition.STUN:
				pass
			Status_Library.StatusCondition.POISON:
				pass
			Status_Library.StatusCondition.FROZEN:
				pass
			Status_Library.StatusCondition.ATKBUFF:
				pass
			Status_Library.StatusCondition.ATKDEBUFF:
				pass
			Status_Library.StatusCondition.DEFBUFF:
				pass
			Status_Library.StatusCondition.DEFDEBUFF:
				pass
			Status_Library.StatusCondition.CURE:
				pass
			Status_Library.StatusCondition.BURN:
				pass
				
		#minus 1 from timeout 
		if status_timeouts[condition_index] > 1:
			status_timeouts[condition_index] -=1
			condition_index+=1
		elif status_timeouts[condition_index] == 1:
			print(name, ": statuses is now: ",  status_conditions)
			print(name, ": status timeout is now: ",  status_timeouts)
			var remove_index = status_conditions.find(status)
			print("remove index sanity check it : ",remove_index)
			status_conditions.remove_at(remove_index)
			status_timeouts.remove_at(remove_index)
		else:
			pass
		
		
		
#	print(name, ": statuses is now: ",  status_conditions)
#	print(name, ": status timeout is now: ",  status_timeouts)
			
	update_statuses()
func update_statuses():
	for status_container in status_grid.get_children():
		status_container.update_status()
