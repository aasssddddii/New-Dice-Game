extends TextureButton
class_name Enemy

var master:Node = self

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


#attack_data = {
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
	
	#deal Damage
	current_enemy_resource.health -= attack_data["damage"]
	
	
	
	#add Status conditions
	if !attack_data["status_conditions"].is_empty():
		for status in attack_data["status_conditions"]:
			add_status_conditions(status)
	update_vitals()
	

func update_vitals():
	ui_health.text = var_to_str(current_enemy_resource.health)
	ui_shield.text = var_to_str(current_enemy_resource.shield)

#func update_health():
#	pass

func setup_next_attack():
	attack_pattern.clear()
	reset_ui_turn()
	manage_enemy_heal("reset",null)
	var remove_stun:bool = false
	for attack_number in current_enemy_resource.attacks:

		if status_conditions.find(Status_Library.StatusCondition.STUN) == -1:
			if status_conditions.find(Status_Library.StatusCondition.DISARM) != -1:
				attack_pattern.append(current_enemy_resource.possible_turn_actions[randi_range(1,2)])
			else:
				attack_pattern.append(current_enemy_resource.possible_turn_actions.pick_random())
		else:
			remove_stun = true
			attack_pattern.append(enemy_resource.TurnActions.NONE)
	#print(name," attack pattern: ", attack_pattern)
	ui_calc_turn()
	display_turn_actions(attack_pattern)
	if remove_stun:
			var stun_index = status_conditions.find(Status_Library.StatusCondition.STUN)
			status_conditions.remove_at(stun_index)
			status_timeouts.remove_at(stun_index)


func get_status_dmg():
	var total_status_dmg:int
	var player_attack:int = game_manager.player_resource.attack
	for status in status_conditions:
		if status != -1:
			var status_ref = game_manager.status_lib.get_status_data(status)
			total_status_dmg += status_ref["damage"]
		
	return total_status_dmg

func display_turn_actions(attack_pattern:Array[enemy_resource.TurnActions]):
	for turn in attack_pattern:
		var next_turn_ui = enemy_ui_turn.instantiate()
		match turn:
			enemy_resource.TurnActions.ATTACK:
				next_turn_ui.setup_ui_turn(current_enemy_resource.attack_texture)
			enemy_resource.TurnActions.DEFEND:
				next_turn_ui.setup_ui_turn(current_enemy_resource.defend_texture)
			enemy_resource.TurnActions.HEAL:
				next_turn_ui.setup_ui_turn(current_enemy_resource.heal_texture)
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
			enemy_resource.TurnActions.HEAL:
				var enemy_layer = get_parent()
				var lowest_hp:int = 4775807
				var target_enemy:Enemy
				#find lowest target
				for enemy in enemy_layer.get_children():
					if lowest_hp > enemy.current_enemy_resource.health:
						target_enemy = enemy
						lowest_hp = enemy.current_enemy_resource.health
					
				if target_enemy != self:
					target_enemy.manage_enemy_heal("set",current_enemy_resource.heal_power)
				else:
					manage_enemy_heal("set",current_enemy_resource.heal_power)
				
			enemy_resource.TurnActions.NONE:
				pass
	
	
	if calc_shield >0:
		calc_ui_shield.visible = true
		calc_ui_shield.text ="+"+var_to_str(calc_shield)
	else:
		calc_ui_shield.visible = false
	heal_calc = enemy_heal - (current_player_damage + get_status_dmg())
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
		
#		print("statuses is now: ",  status_conditions)
#		print("status timeout is now: ",  status_timeouts)
		
		if spawned_statuses.find(value) == -1:
			spawned_statuses.append(value)
			var next_ui_status = game_manager.status_lib.status_prefab.instantiate()
			status_grid.add_child(next_ui_status)
			next_ui_status.setup_status(status_ref)
			
		#print("adding statuses is now: ",  status_conditions)
		#print("adding status timeout is now: ",  status_timeouts)
			
func do_status_effects():
	print(name, ": statuses is now: ",  status_conditions)
	print(name, ": status timeout is now: ",  status_timeouts)
	var condition_index:int
	for status in status_conditions:
		#do status damages

		
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
			if status != -1:
				var status_ref = game_manager.status_lib.get_status_data(status)
				current_enemy_resource.health -= status_ref["damage"]
				print(name, " is taking damage from status DMG: ", status_ref["damage"])
		elif status == Status_Library.StatusCondition.STUN:
			pass
		else:
			#var remove_index = status_conditions.find(status)
			#print("condition index sanity check it : ",condition_index)
			status_conditions.pop_at(condition_index)
			status_timeouts.pop_at(condition_index)
			status_conditions.insert(condition_index,-1)
			status_timeouts.insert(condition_index,0)
			
			
			#print(name, ": statuses is now: ",  status_conditions)
			#print(name, ": status timeout is now: ",  status_timeouts)
		condition_index+=1
		
		
			
	update_statuses()
func update_statuses():
	for status_container in status_grid.get_children():
		status_container.update_status()
		
func get_attack_data():
	var send_attack:Dictionary = {
		"damage":0,
		"status_effect":Status_Library.StatusCondition.NONE,
	}
	for action in attack_pattern:
		match action:
			enemy_resource.TurnActions.ATTACK:
				send_attack["damage"] += current_enemy_resource.attack
				if current_enemy_resource.basic_attack_damage_type != 6:#NONe DMG type
					match current_enemy_resource.basic_attack_damage_type:
						Dice.DamageElement.POISON:
							send_attack["status_effect"] = Status_Library.StatusCondition.POISON
						Dice.DamageElement.NONE:
							pass
						_:
							print("status not implemented template_enemy.gd")
							
					
	return send_attack

