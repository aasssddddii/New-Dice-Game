extends TextureButton
class_name Enemy

var master:Node = self

signal vitals_changed
signal status_changed(status_conditions:Array[Status_Library.StatusCondition])

var game_manager = GameManager
var current_enemy_resource:Resource
var status_lib = Status_Library
var attack_data:Dictionary
@onready var dice_battle_node = $"../.."
@onready var ui_turns = $ui_turns
var enemy_ui_turn = load("res://Prefabs/game_ui/enemy_turn_ui.tscn")
var attack_pattern:Array[enemy_resource.TurnActions]

var current_player_damage:int
#var enemy_heal:int
var heal_calc
var attack_calc

var status_conditions:Array[Status_Library.StatusCondition]
var status_timeouts:Array[int]
var spawned_statuses:Array[Status_Library.StatusCondition]

var target_enemy:Enemy
var heal_amount:int

var trap_countdown:int = -1
var trap_key:Array[Dice.DiceType] = []


@onready var status_grid = $status_conditions
#DISPLAY TURN
@onready var calc_ui_shield = $ui_calc/ui_shield
@onready var calc_ui_heal = $ui_calc/ui_health
@onready var calc_ui_attack = $ui_calc/ui_attack
#UI Current
@onready var ui_health = $ui_current/ui_health
@onready var ui_shield = $ui_current/ui_shield




var ui_heal_added:bool = false

var arm_ties:int = 0

func setup_enemy(resource:Resource):
	current_enemy_resource = resource.duplicate()
	name = current_enemy_resource.enemy_name
	texture_normal = current_enemy_resource.main_texture
	ui_health.text = var_to_str(current_enemy_resource.health)
	
	vitals_changed.connect(update_vitals)
	global_position -= Vector2(64,64)
	if dice_battle_node.is_trap_battle:
		set_trap_key()
	
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
	if game_manager.player_resource.piercing >=1:
		var piercing_dmg = int(attack_data["damage"] / (11-game_manager.player_resource.piercing))
		deal_damage(piercing_dmg,true)
		attack_data["damage"]-=piercing_dmg
		deal_damage(attack_data["damage"],false)
		print("piercing damage: ", piercing_dmg, " rest of damage: ",attack_data["damage"])
	else:
		#deal Damage
		deal_damage(attack_data["damage"],false)
	#add Status conditions
	if !attack_data["status_conditions"].is_empty():
		for status in attack_data["status_conditions"]:
			add_status_conditions(status)
	
	

func update_vitals():
	ui_health.text = var_to_str(current_enemy_resource.health)
	ui_shield.text = var_to_str(current_enemy_resource.shield)

func deal_damage(amount:int, direct_damage:bool):
	if !direct_damage:
		var enemy_shield = current_enemy_resource.shield
		if  enemy_shield > amount:
			#print("dealing ", amount ," damage to shield")
			current_enemy_resource.shield -= amount
		else:
			amount -= enemy_shield
			current_enemy_resource.shield = 0
			#print("dealing ", amount ," damage to enemy shield overrun")
			current_enemy_resource.health -= amount
	else:
		current_enemy_resource.health -= amount
	
	
	#Kill check
	if current_enemy_resource.health <= 0:
		var left_enemies:Array[Enemy]
		var dice_game = $"../.."
		for child in get_parent().get_children():
			if child != self:
				left_enemies.append(child)
		if !left_enemies.is_empty():
			dice_game.update_player_target(left_enemies.pick_random())
		else:
			dice_game.end_battle(true)
		queue_free()
	#update_vitals()
	kill_check()
	vitals_changed.emit()

func setup_next_attack():
	arm_ties = 0
	if !dice_battle_node.is_trap_battle:#Regular battle
		attack_pattern.clear()
		reset_ui_turn()
		#update_vitals()
		vitals_changed.emit()
		#manage_enemy_heal("reset",null)
		var remove_stun:bool = false
		for attack_number in current_enemy_resource.attacks:

			if status_conditions.find(Status_Library.StatusCondition.STUN) == -1 &&  status_conditions.find(Status_Library.StatusCondition.FROZEN) == -1:
				if status_conditions.find(Status_Library.StatusCondition.DISARM) != -1:
					attack_pattern.append(current_enemy_resource.possible_turn_actions[randi_range(1,2)])
				else:
					attack_pattern.append(current_enemy_resource.possible_turn_actions.pick_random())
			else:
				if status_conditions.find(Status_Library.StatusCondition.STUN) != -1:
					remove_stun = true
					attack_pattern.append(enemy_resource.TurnActions.NONE)
				elif status_conditions.find(Status_Library.StatusCondition.FROZEN) != -1:
					attack_pattern.append(enemy_resource.TurnActions.NONE)
					
		#print(name," attack pattern: ", attack_pattern)
		ui_calc_turn()
		display_turn_actions(attack_pattern)
		if remove_stun:
				var stun_index = status_conditions.find(Status_Library.StatusCondition.STUN)
				status_conditions.remove_at(stun_index)
				status_timeouts.remove_at(stun_index)
	else:#Trap battle
		#print("I AM A TRAP!!!")
		if trap_countdown == -1:
			trap_countdown = 5
		elif trap_countdown >= 1:
			trap_countdown -= 1
		elif trap_countdown <= 0:
			#spring trap code here
			#deal_damage(current_enemy_resource.health)
			spring_trap()
			kill_check()
			
		ui_calc_turn()
		

func get_status_dmg():
	var total_status_dmg:int
	var player_attack:int = game_manager.player_resource.attack
	for status in status_conditions:
		if status != -1:
			var status_ref = game_manager.status_lib.get_status_data(status)
			total_status_dmg += status_ref["damage"]
		
	return total_status_dmg

func update_action_pattern(status:Status_Library.StatusCondition):
	if status != null:
		#print("sanity check on status value: ", status, " vs ", Status_Library.StatusCondition.FROZEN)
		if status == 5:
			attack_pattern.clear()
			reset_ui_turn()
			for attack in current_enemy_resource.attacks:
				#print("SANITY TEST III")
				attack_pattern.append(enemy_resource.TurnActions.NONE)
		elif status == Status_Library.StatusCondition.DISARM:
			var turn_index:int
			#print("attack pattern before disarm: ", attack_pattern)
			for attack in attack_pattern:
				if attack == enemy_resource.TurnActions.ATTACK:
					#print("this attack should be changed!!! at index: ", turn_index)
					attack_pattern.remove_at(turn_index)
					attack_pattern.insert(turn_index,enemy_resource.TurnActions.NONE)
				turn_index +=1
			reset_ui_turn()
			#print("attack pattern after disarm: ", attack_pattern)
		display_turn_actions(attack_pattern)
		ui_calc_turn()

func use_armtie():
	attack_pattern.remove_at(attack_pattern.find(attack_pattern.pick_random()))
	reset_ui_turn()
	display_turn_actions(attack_pattern)

func display_turn_actions(input_pattern:Array[enemy_resource.TurnActions]):
	for turn in input_pattern:
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

func set_trap_key():
	var player_dice_deck = game_manager.player_resource.dice_deck.duplicate()
	var only_one_dice_deck = only_one(player_dice_deck)
	var possible_key_values = convert_dice_to_type(only_one_dice_deck)
	possible_key_values.append(Dice.DiceType.NONE)
	
	for key_index in 3:
		var next_key_value = possible_key_values.pick_random()
		trap_key.append(next_key_value)#need to pick dice type for trap key here
		var next_turn_ui = enemy_ui_turn.instantiate()
		
		next_turn_ui.setup_ui_turn(load(game_manager.dice_lib.get_sprite_from_type(next_key_value)))#This will show the key to the player
		
		ui_turns.add_child(next_turn_ui)
		
	#print("TRAP KEY CODE IS: ", trap_key)

func only_one(input_array):
	var output_array:Array[Dictionary]
	for value in input_array:
		if !output_array.any(func(checker):return checker == value):
			output_array.append(value)
	return output_array

func convert_dice_to_type(input_array):
	var output_array:Array[Dice.DiceType]
	for value in input_array:
		output_array.append(game_manager.dice_lib.get_dice_type(value["item_name"]))
	return output_array

func reset_ui_turn():
	#heal_calc = 0
	ui_heal_added = false
	for turn_display in ui_turns.get_children():
		turn_display.queue_free()

func ui_calc_turn():
	if !dice_battle_node.is_trap_battle:
		#var calc_heal:int
		var calc_shield:int
		attack_calc = 0
		
		var enemy_attack = current_enemy_resource.attack
		if status_conditions.has(Status_Library.StatusCondition.ATKDEBUFF):
			enemy_attack /= 2
		
		#VVVV Maybe change this to a function that creates an attack Dictionary like player
		for attack in attack_pattern:
#			if name == "wizard":
#				print(name, " attack pattern check, ", attack_pattern)
			match attack:
				enemy_resource.TurnActions.ATTACK:
					attack_calc += enemy_attack
					pass
				enemy_resource.TurnActions.DEFEND:
					calc_shield += current_enemy_resource.defend
					pass
				enemy_resource.TurnActions.HEAL:
					if !ui_heal_added:
						var enemy_layer = get_parent()
						var lowest_hp:int = 4775807
						target_enemy=null
						#find lowest target
						for enemy in enemy_layer.get_children():
							if lowest_hp >= enemy.current_enemy_resource.health:
								target_enemy = enemy
								lowest_hp = enemy.current_enemy_resource.health
						#heal_amount += current_enemy_resource.heal_power
						#print(name, " is targeting enemy: ",target_enemy.name, " heal amount ", heal_amount, " heal power sanity check ",current_enemy_resource.heal_power)
						if target_enemy != self:
							#print("heal target = ", target_enemy.name, " setting enemy heal to ",current_enemy_resource.heal_power)
							target_enemy.manage_heal_amount("add",current_enemy_resource.heal_power) 
							#^^^^ NEEDS to be limited so that it does not keep adding to infinity when clicked
						else:
							#print("heal target = ", name, " setting self heal to ",current_enemy_resource.heal_power)
							heal_amount += current_enemy_resource.heal_power
						ui_heal_added = true
					pass
				enemy_resource.TurnActions.NONE:
					pass
		
		
		if calc_shield >0:
			calc_ui_shield.visible = true
			calc_ui_shield.text ="+"+var_to_str(calc_shield)
		else:
			calc_ui_shield.visible = false
		heal_calc = heal_amount #- (current_player_damage + get_status_dmg())
		if heal_calc > 0 :
			calc_ui_heal.visible = true
			calc_ui_heal.text ="+"+var_to_str(heal_calc)
		else:
			calc_ui_heal.visible = false
		if attack_calc > 0:
			calc_ui_attack.visible = true
			calc_ui_attack.text = var_to_str(attack_calc)
		else:
			calc_ui_attack.visible = false
		
		#print(name,"attack calc: ", attack_calc ," heal calc: ", heal_calc, " heal amount sanity check ", heal_amount)
	else:
		attack_calc = trap_countdown
		calc_ui_attack.text = var_to_str(attack_calc)
		
		
		
func show_arrow(choice:bool):
	var arrow = $target_arrow
	if choice:
		arrow.visible = true
	else:
		arrow.visible = false

func _on_button_down():
	$"../..".update_player_target(self)
	pass # Replace with function body.


func manage_heal_amount(choice:String,value):
	match choice:
		"reset":
			heal_amount = 0
		"set":
			heal_amount = value
		"add":
			heal_amount += value

	#print(name, " enemy heal now: ", heal_amount)
	ui_calc_turn()
	

func add_status_conditions(value):
	if !dice_battle_node.is_trap_battle:
		if typeof(value) != TYPE_ARRAY:
			var status_ref = game_manager.status_lib.get_status_data(value)
			status_conditions.append(value)
			status_timeouts.append(status_ref["turns"])
			#LLO 6/8
			#if freeze, stun or disarm, change attack pattern
			if value == Status_Library.StatusCondition.FROZEN||value == game_manager.status_lib.StatusCondition.STUN||value == game_manager.status_lib.StatusCondition.DISARM:
				update_action_pattern(value)
			# shows statuses in gridVVVV
			status_changed.emit(status_conditions)
			
			
func do_status_effects():
	print(name, ": statuses is now: ",  status_conditions)
	print(name, ": status timeout is now: ",  status_timeouts)
	var condition_index:int
	for status in status_conditions.duplicate():
		#minus 1 from timeout 
		if status_timeouts[condition_index] > 1 && (status != Status_Library.StatusCondition.FROZEN && status != Status_Library.StatusCondition.STUN):
			status_timeouts[condition_index] -=1
			if status != -1:
				var status_ref = game_manager.status_lib.get_status_data(status)
				if status_ref["name"] == "bleed" || status_ref["name"] == "poison":
					deal_damage(status_ref["damage"],true)
				else:
					deal_damage(status_ref["damage"],false)
				#print(name, " is taking damage from status DMG: ", status_ref["damage"])
				if status_ref["name"] != "disarm":
					await turn_tween("status").finished
				self_modulate = Color.WHITE
		elif status == Status_Library.StatusCondition.STUN && status_timeouts[condition_index] > 1:
			status_timeouts[condition_index] -=1
			pass
		elif status == Status_Library.StatusCondition.FROZEN && status_timeouts[condition_index] > 1:
			status_timeouts[condition_index] -=1
			pass
		else:
			if status != -1:
				var status_ref = game_manager.status_lib.get_status_data(status)
				if status_ref["name"] == "bleed" || status_ref["name"] == "poison":
					deal_damage(status_ref["damage"],true)
				else:
					deal_damage(status_ref["damage"],false)
				#print(name, " is taking damage from status DMG: ", status_ref["damage"])
				if status_ref["name"] != "disarm" && status_ref["name"] != "stun" && status_ref["name"] != "frozen":
					await turn_tween("status").finished
				self_modulate = Color.WHITE			
			status_conditions.remove_at(condition_index)
			status_timeouts.remove_at(condition_index)
			status_changed.emit(status_conditions)
			condition_index-=1
		
		condition_index+=1
	
	
#func update_statuses():
#	for status_container in status_grid.get_children():
#		status_container.update_status()
		
		
#func animate_status_damage(status:Status_Library.StatusCondition):
#	#var flash_color:Color
#	#var status_animator:AnimationPlayer = $status_animator
#	#flash_timer.stop()
#	match status:
#		Status_Library.StatusCondition.POISON:
#			flash_color = Color.GREEN
#		Status_Library.StatusCondition.BLEED:
#			flash_color = Color.BROWN
#		Status_Library.StatusCondition.BURN:
#			flash_color = Color.INDIAN_RED
#
#	self_modulate = flash_color
#	flash_timer.start()
#	return flash_timer
	
#func clean_up_statuses():
#	#var status_index:int
#	var clean_status:Array[Status_Library.StatusCondition]
#	var clean_timeout:Array[int]
#
#	for status in status_conditions:
#		print("sanity check status = ", status)
#		if status != -1:
#			clean_status.append(status)
#			#doesnt work due to .find only getting first result May also effect player
#			clean_timeout.append(status_timeouts[status_conditions.find(status)])
#
#	status_conditions = clean_status
#	status_timeouts = clean_timeout
#
#	print(name, ": statuses is now: ",  status_conditions)
#	print(name, ": status timeout is now: ",  status_timeouts)
	
	
	
var send_attack:Dictionary
	#actually take enemy turn
func do_attack_pattern():
	send_attack = {
		"damage":0,
		"status_effect":Status_Library.StatusCondition.NONE,
		#Maybe add a send Heal so the dice game can send it to the correct enemy
		"target_enemy":null,
		"heal_amount":0,
		"from_enemy":self
	}
	for action in attack_pattern:
		match action:
			enemy_resource.TurnActions.ATTACK:
				var enemy_attack = current_enemy_resource.attack
				if status_conditions.has(Status_Library.StatusCondition.ATKDEBUFF):
					enemy_attack /= 2
				send_attack["damage"] += enemy_attack
				if current_enemy_resource.basic_attack_damage_type != 6:#NONe DMG type
					match current_enemy_resource.basic_attack_damage_type:
						Dice.DamageElement.POISON:
							send_attack["status_effect"] = Status_Library.StatusCondition.POISON
						Dice.DamageElement.BLEED:
							send_attack["status_effect"] = Status_Library.StatusCondition.BLEED
						Dice.DamageElement.FIRE:
							send_attack["status_effect"] = Status_Library.StatusCondition.BURN
						Dice.DamageElement.NONE:
							pass
						_:
							print("status not implemented template_enemy.gd")
							
				await turn_tween("attack").finished
				dice_battle_node.hit_player(send_attack)
				if game_manager.player_resource.thorns >= 1:
					deal_damage(game_manager.player_resource.thorns*2,false)
			enemy_resource.TurnActions.DEFEND:
				if current_enemy_resource.shield < current_enemy_resource.max_health:
					current_enemy_resource.shield += current_enemy_resource.defend
				if current_enemy_resource.shield > current_enemy_resource.max_health:
					current_enemy_resource.shield = current_enemy_resource.max_health
				await turn_tween("defend").finished
				update_vitals()
			enemy_resource.TurnActions.HEAL:
				await turn_tween("heal").finished
#				send_attack["target_enemy"] = target_enemy
#				send_attack["heal_amount"] += current_enemy_resource.heal_power
	#dice_battle_node.hit_player(send_attack)
	do_status_effects()
	#clean_up_statuses()
	setup_next_attack()

func heal_enemy():
	#print("Healing enemy ", name, " current heal ", (heal_amount-get_status_dmg()))
	
	if current_enemy_resource.health < current_enemy_resource.max_health:
		current_enemy_resource.health += heal_amount 
	if current_enemy_resource.health > current_enemy_resource.max_health:
		current_enemy_resource.health = current_enemy_resource.max_health 


func turn_tween(choice:String):
	
	var tweener = get_tree().create_tween()
	var reset_position = position
	var move_direction
	match choice:
		"attack":
			move_direction = Vector2(-80,0)
		"defend":
			move_direction = Vector2(0,-80)
		"heal":
			move_direction = Vector2(20,0)
		"status":
			move_direction = Vector2(40,0)
		"none":
			move_direction = Vector2(0,0)
	
	tweener.tween_property(self,"position",position + move_direction,.1)
	tweener.tween_property(self,"position",reset_position,.2)
	
	return tweener
	
	
func kill_check():
	var arrow = $target_arrow
	if current_enemy_resource.health <= 0:
		var filtered_targets = get_parent().get_children().filter(func(target):return target != self)
		if dice_battle_node.is_trap_battle:
			dice_battle_node.trap_disarmed = true
		#maybe add something about adding to the player kills
		if arrow.visible:
			if !filtered_targets.is_empty():
				$"../..".update_player_target(filtered_targets.pick_random())
				
				
		if game_manager.player_resource.vamp_thread >=1:
			$"../..".heal_player(game_manager.player_resource.heal_power * game_manager.player_resource.vamp_thread)
		queue_free()

func spring_trap():
	send_attack = {
		"damage":current_enemy_resource.attack,
		"status_effect":Status_Library.StatusCondition.NONE,
		#Maybe add a send Heal so the dice game can send it to the correct enemy
		"target_enemy":null,
		"heal_amount":0,
		"from_enemy":self
	}
	dice_battle_node.hit_player(send_attack)
	#Maybe change trap to sprung image
	$"../..".end_battle(true)
	queue_free()
	
func get_attack_dice_data():
	var dice_data
	match current_enemy_resource.basic_attack_damage_type:
		Dice.DamageElement.FIRE:
			dice_data = game_manager.dice_lib.fire_dice_shop_data
		Dice.DamageElement.ICE:
			dice_data = game_manager.dice_lib.ice_dice_shop_data
		Dice.DamageElement.LIGHTNING:
			dice_data = game_manager.dice_lib.lightning_dice_shop_data
		Dice.DamageElement.POISON:
			dice_data = game_manager.dice_lib.poison_dice_shop_data
#		Dice.DamageElement.WATER:
#			pass
		Dice.DamageElement.BLEED:
			dice_data = game_manager.dice_lib.bleed_dice_shop_data
		Dice.DamageElement.NONE:
			dice_data = game_manager.dice_lib.attack_dice_shop_data
			
	#Leaving space for upgrading dice based on difficulty/ randomness
	
	return dice_data
