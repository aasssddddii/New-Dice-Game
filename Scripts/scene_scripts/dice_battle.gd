extends Node2D

signal vitals_changed

@onready var player_hand = $player_hand
@onready var dice_layer = $dice_layer
@onready var action_slots = $action_slots
@onready var enemy_spawns = $enemy_spawns
@onready var enemy_layer = $enemy_layer
@onready var status_grid = $player_layer/player/status_conditions
@onready var dice_lib = preload("res://Resources/dice_library.tres")
#var enemy_lib #= preload("res://Resources/enemies/enemy_library.tres")

var current_dice_deck:Array[Dictionary]
var discard:Array[Dictionary]
var battle_data:Array[Resource]
var game_manager = GameManager

var status_conditions:Array[Status_Library.StatusCondition]
var status_timeout:Array[int]

var current_enemy_dmg:int

var player_target:Enemy

var spawned_statuses:Array[Status_Library.StatusCondition]

var reward

#ui
@onready var ui_hp = $player_layer/player/VBoxContainer/ui_hp/ui_text
@onready var ui_shield = $player_layer/player/VBoxContainer/ui_shield/ui_text
@onready var ui_damage = $player_ui/ui_damage
#calc
@onready var ui_calc_hp = $player_layer/player/calc_hp
@onready var ui_calc_defend = $player_layer/player/calc_defend

var can_attack:bool = true
var enemy_count:int

#LLO WORKING ON THE BATTLE FLOW IN GENERAL
#Staticly set battle need to get ready for map generation
func setup_dice_batle(input_data:Dictionary):
	#enemy_lib = preload("res://Resources/enemies/enemy_library.tres")
	current_dice_deck = game_manager.player_resource.getset_dice_deck("get", null)
	#print("setting up deck: ", current_dice_deck)
#	battle_data = [
#		enemy_lib.get_enemy_resource("snake"),
#		enemy_lib.get_enemy_resource("wizard"),
#		enemy_lib.get_enemy_resource("ice_wolf")]
		
	battle_data = input_data["enemies"]
	reward = input_data["reward"]
	
	for ui_slot in action_slots.get_children():
		ui_slot.get_child(0).action_slot_filled.connect(calc_player_attack)
		ui_slot.get_child(0).action_slot_unfilled.connect(calc_player_attack)
	
	#setup player
	update_vitals()
	vitals_changed.connect(update_vitals)
	
	setup_enemies()
	update_player_target(enemy_layer.get_child(0))
	set_player_hand()


func setup_enemies():
	if !battle_data.is_empty():
		var enemy_counter:int
		for enemy in battle_data:
			var next_enemy = game_manager.enemy_lib.enemy_prefab.instantiate()
			next_enemy.position = enemy_spawns.get_child(enemy_counter).position
			enemy_layer.add_child(next_enemy)
			next_enemy.setup_enemy(enemy)
			
			enemy_counter+=1
		
		enemy_count = enemy_counter
		current_enemy_dmg = calc_enemy_dmg()
		calc_player_attack()
		print("total enemy attack: ", current_enemy_dmg)
	#get enemies from battle data
	#for each enemy create the enemy from the enemy prefab
	#setup enemy using enemy library enemy data
	pass

func set_player_hand():
	#print("current dice deck: ", current_dice_deck)
	
	var hand_slots_not_filled = player_hand.get_children().filter(func(slot):return !slot.get_child(0).is_filled)

	for slot in hand_slots_not_filled:
		if current_dice_deck.size() < 1:
			shuffle_deck()
			
			var next_dice = dice_lib.dice_prefab.instantiate()
			next_dice.scale = Vector2(.7,.7)
			var next_dice_data = current_dice_deck.pick_random()
			current_dice_deck.remove_at(current_dice_deck.find(next_dice_data))
			if next_dice_data["default"]:
				#print("setting up dice: ", dice_lib.get_dice_data(next_dice_data["dice_name"]))
				next_dice.set_dice_data(dice_lib.get_dice_data(next_dice_data["dice_name"]))#dice library reference
			else:
				next_dice.set_dice_data()#player library reference
				
			next_dice.name = next_dice_data["dice_name"]
			dice_layer.add_child(next_dice)
			next_dice.global_position = slot.global_position + dice_lib.die_offset
			next_dice.last_snap_area = slot.get_child(0)
		else:
			var next_dice = dice_lib.dice_prefab.instantiate()
			next_dice.scale = Vector2(.7,.7)
			var next_dice_data = current_dice_deck.pick_random()
			current_dice_deck.remove_at(current_dice_deck.find(next_dice_data))
			if next_dice_data["default"]:
				#print("setting up dice: ", dice_lib.get_dice_data(next_dice_data["dice_name"]))
				next_dice.set_dice_data(dice_lib.get_dice_data(next_dice_data["dice_name"]))#dice library reference
			else:
				next_dice.set_dice_data()#player library reference
				
			next_dice.name = next_dice_data["dice_name"]
			dice_layer.add_child(next_dice)
			next_dice.global_position = slot.global_position + dice_lib.die_offset
			next_dice.last_snap_area = slot.get_child(0)
	
	
	display_player_calc()

func shuffle_deck():
	current_dice_deck += discard
	#print("adding discard: ", discard)
	discard.clear()
	print("current deck after shuffle: ", current_dice_deck)

func use_dice(dice_array:Array[Dice]):
	#Send Player Attack Data Here
	for die in dice_array:
		var dice_data = die.dice_data
		
		#print("using ", dice_data["item_name"])
		#Send Attack Data
		
		
		if dice_lib.default_checker(dice_data):
			discard.append({
				"default":true,
				"dice_name":dice_data["item_name"]
			})
		else:
			discard.append(dice_data)
		die.queue_free()
		
	set_player_hand()

#Player ENDS turn here
func _on_submit_button_down():
	if can_attack:
		can_attack = false
		$player_ui/submit_button.modulate = Color.SADDLE_BROWN
		var send_dice:Array[Dice]
		for slot in action_slots.get_children():
			var slot_area = slot.get_child(0)
			if slot_area.is_filled:
				var dice_node = slot_area.filled_node
				send_dice.append(dice_node)
		use_dice(send_dice)
		
		do_positive_statuses()#does positive statuses
		print("sending attack: ", player_attack)
		#evaluate player specific data
		
#		game_manager.player_resource.gold += player_attack["gold"]
#		print("player gained ", player_attack["gold"], " gold")
#
#		game_manager.player_resource.shield += player_attack["shield"]
#		game_manager.player_resource.health += player_attack["heal"]
		manage_positive_player_attack(player_attack["heal"],player_attack["shield"],player_attack["gold"])
		player_target.hit_enemy(player_attack)
		reset_player_attack()
		
		vitals_changed.emit()
		await get_tree().create_timer(.7).timeout
		#do_status_effects()
		#clean_up_statuses()
		take_enemy_turn()
		current_enemy_dmg = calc_enemy_dmg()
		calc_player_attack()
		#print("total enemy attack: ", current_enemy_dmg)
	else:
		print("not player turn yet...")

func calc_enemy_dmg():
	var enemy_calc_attack:int
	
	for enemy in enemy_layer.get_children():
		var enemy_attack_pattern = enemy.attack_pattern
		for attack in enemy_attack_pattern:
			if attack == enemy_resource.TurnActions.ATTACK:
				enemy_calc_attack += enemy.current_enemy_resource.attack
	#print("total enemy attack: ", enemy_calc_attack)
	return enemy_calc_attack

func manage_positive_player_attack(heal:int,shield:int,gold:int):
	game_manager.player_resource.gold += player_attack["gold"]
	#print("player gained ", player_attack["gold"], " gold")
	
	game_manager.player_resource.shield += player_attack["shield"]
	#max shield check
	if game_manager.player_resource.shield > game_manager.player_resource.max_health:
		game_manager.player_resource.shield = game_manager.player_resource.max_health
	
	game_manager.player_resource.health += player_attack["heal"]
	#max heal check
	if game_manager.player_resource.health > game_manager.player_resource.max_health:
		game_manager.player_resource.health = game_manager.player_resource.max_health
	


func get_action_dice():
	var send_dice:Array[Dice]
	for ui_slot in action_slots.get_children():
		var action_area = ui_slot.get_child(0)
		if action_area.is_filled:
			if action_area.filled_node != null:
				send_dice.append(action_area.filled_node)
	
	return send_dice

var player_attack:Dictionary 

func calc_player_attack():
	var action_slot_dice = get_action_dice()
	var calculator_damage:int
	var calculator_reflect:int
	var calculator_defend:int
	var calculator_heal:int
	var calculator_gold:int
	var calculator_statuses:Array[Status_Library.StatusCondition]
	var calculator_elements:Array[Dice.DamageElement]
	var calculator_element_dmg:Array[int]
	
	
	#print("calculating value based on slot data: ", action_slot_dice)
	for die in action_slot_dice:
		if die.up_face >= 1:
			#print("calculating next die: ", die.name)
			var die_data = die.dice_data
			#still need to calculate enemy resistantses/weaknesses
			#still need to add all same bonus
			match die_data["type"]:
				Dice.DiceType.ATTACK:
					calculator_damage += game_manager.player_resource.attack
				Dice.DiceType.DEFEND:
					calculator_defend += game_manager.player_resource.defend
				Dice.DiceType.REROLL:
					pass
				Dice.DiceType.BLEED:
					if calculator_statuses.find(Status_Library.StatusCondition.BLEED) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.BLEED)
						
					if player_target.current_enemy_resource.resistantses[Dice.DamageElement.BLEED]:
						calculator_damage += (game_manager.player_resource.attack*.75)/2
					else:
						calculator_damage += (game_manager.player_resource.attack*.75)
				Dice.DiceType.HEAL:
					calculator_heal += game_manager.player_resource.heal_power
				Dice.DiceType.GOLD:
					calculator_damage += 1
					calculator_gold += 1
				Dice.DiceType.REFLECT:
					calculator_statuses.append(Status_Library.StatusCondition.REFLECT)
				Dice.DiceType.LIFESTEAL:
					calculator_damage += game_manager.player_resource.attack
					#need to take enemy HP into account
					calculator_heal += game_manager.player_resource.attack/2
				Dice.DiceType.POISON:
					calculator_damage += (game_manager.player_resource.attack /2)
					if calculator_statuses.find(Status_Library.StatusCondition.POISON) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.POISON)
					if player_target.current_enemy_resource.resistantses[Dice.DamageElement.POISON]:
						calculator_damage += (game_manager.player_resource.attack*.5)/2
					elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.POISON]:
						calculator_damage += game_manager.player_resource.attack
					else:
						calculator_damage += (game_manager.player_resource.attack*.5)
				Dice.DiceType.CURE:
					if calculator_statuses.find(Status_Library.StatusCondition.CURE) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.CURE)
				Dice.DiceType.DISARM:
					calculator_damage += 1
					if calculator_statuses.find(Status_Library.StatusCondition.DISARM) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.DISARM)
				Dice.DiceType.STUN:
					calculator_damage += 1
					if calculator_statuses.find(Status_Library.StatusCondition.STUN) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.STUN)
				Dice.DiceType.ATKBUFF:
					if calculator_statuses.find(Status_Library.StatusCondition.ATKBUFF) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.ATKBUFF)
				Dice.DiceType.DEFBUFF:
					if calculator_statuses.find(Status_Library.StatusCondition.DEFBUFF) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.DEFBUFF)
				Dice.DiceType.ATKDEBUFF:
					if calculator_statuses.find(Status_Library.StatusCondition.ATKDEBUFF) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.ATKDEBUFF)
				Dice.DiceType.DEFDEBUFF:
					if calculator_statuses.find(Status_Library.StatusCondition.DEFDEBUFF) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.DEFDEBUFF)
				Dice.DiceType.FIRE:
					var element_dmg:int
					#calculator_damage += (game_manager.player_resource.attack /2)
					if calculator_statuses.find(Status_Library.StatusCondition.BURN) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.BURN)
						
						
					if player_target.current_enemy_resource.resistantses[Dice.DamageElement.FIRE]:
						calculator_damage += (game_manager.player_resource.attack*.5)/2
						element_dmg= (game_manager.player_resource.attack*.5)/2
					elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.FIRE]:
						calculator_damage += game_manager.player_resource.attack
						element_dmg= game_manager.player_resource.attack
					else:
						calculator_damage += (game_manager.player_resource.attack*.5)
						element_dmg= (game_manager.player_resource.attack*.5)
						
					if calculator_elements.find(Dice.DamageElement.FIRE) == -1:
						calculator_elements.append(Dice.DamageElement.FIRE)
						calculator_element_dmg.append(element_dmg)
					else:
						var index = calculator_elements.find(Dice.DamageElement.FIRE)
						calculator_element_dmg[index] += element_dmg
				Dice.DiceType.ICE:
					var element_dmg:int
					
					
					if player_target.current_enemy_resource.resistantses[Dice.DamageElement.ICE]:
						calculator_damage += (game_manager.player_resource.attack*.5)/2
						element_dmg= (game_manager.player_resource.attack*.5)/2
					elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.ICE]:
						calculator_damage += game_manager.player_resource.attack
						element_dmg= game_manager.player_resource.attack
					else:
						calculator_damage += (game_manager.player_resource.attack*.5)
						element_dmg= (game_manager.player_resource.attack*.5)
					
					
					if calculator_elements.find(Dice.DamageElement.ICE) == -1:
						calculator_elements.append(Dice.DamageElement.ICE)
						calculator_element_dmg.append(element_dmg)
					else:
						var index = calculator_elements.find(Dice.DamageElement.ICE)
						calculator_element_dmg[index] += element_dmg
				Dice.DiceType.LIGHTNING:
					var element_dmg:int
					
					if player_target.current_enemy_resource.resistantses[Dice.DamageElement.LIGHTNING]:
						calculator_damage += (game_manager.player_resource.attack*.5)/2
						element_dmg= (game_manager.player_resource.attack*.5)/2
					elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.LIGHTNING]:
						calculator_damage += game_manager.player_resource.attack
						element_dmg= game_manager.player_resource.attack
					else:
						calculator_damage += (game_manager.player_resource.attack*.5)
						element_dmg= (game_manager.player_resource.attack*.5)
					
					if calculator_elements.find(Dice.DamageElement.LIGHTNING) == -1:
						calculator_elements.append(Dice.DamageElement.LIGHTNING)
						calculator_element_dmg.append(element_dmg)
					else:
						var index = calculator_elements.find(Dice.DamageElement.LIGHTNING)
						calculator_element_dmg[index] += element_dmg
						
	player_attack = {
	"damage":calculator_damage,
	"reflect":calculator_reflect,
	"shield":calculator_defend,
	"heal":calculator_heal,
	"gold":calculator_gold,
	"status_conditions":calculator_statuses,
	"elements":calculator_elements,
	"element_damage":calculator_element_dmg
	}
	#print("preparing to send attack: ", player_attack)
	display_player_calc()
	update_damage()
	


func display_player_calc():
	update_damage()
	
	if player_attack["heal"] > 0:
		ui_calc_hp.text = "+"+var_to_str(player_attack["heal"])
	else:
		ui_calc_hp.text = var_to_str(player_attack["heal"])
	if player_attack["shield"] >0:
		ui_calc_defend.text = "+"+var_to_str(player_attack["shield"])
	else:
		ui_calc_defend.text = var_to_str(player_attack["shield"])
	
	
	
	#ZERO Checking
	if player_attack["shield"] <=0:
		ui_calc_defend.visible = false
	else:
		ui_calc_defend.visible = true
	if player_attack["heal"] == 0:
		ui_calc_hp.visible = false
	else:
		ui_calc_hp.visible = true

func update_damage():
	print("sanity check player damage: ",player_attack["damage"])
	if player_attack["damage"] > 0:
		ui_damage.text = var_to_str(player_attack["damage"])
		ui_damage.visible = true
	else:
		ui_damage.visible = false

func take_enemy_turn():
	var enemies = enemy_layer.get_children()
	for enemy in enemies:
		#Do enemy Status
		#enemy.do_status_effects()
		#Heal Enemies with heals
		enemy.heal_enemy()
		enemy.heal_amount = 0
	
	
		
	#Do Enemy Attack
	for enemy in enemies:
		await enemy.do_attack_pattern()
		#var next_attack = enemy.send_attack
		#hit_player(next_attack)
		#setup next enemy attack
#		enemy.do_status_effects()
#		enemy.setup_next_attack()
		
		
	do_status_effects()
	
	current_enemy_dmg = calc_enemy_dmg()
	calc_player_attack()
	can_attack = true
	$player_ui/submit_button.modulate = Color.WHITE
	



func hit_player(attack_data:Dictionary):
	print("player takes ", attack_data["damage"]," damage")
	print("adding status effect to player: ", attack_data["status_effect"])
	
	if attack_data["status_effect"] != Status_Library.StatusCondition.NONE:
		add_status_conditions(attack_data["status_effect"])
	
	damage_player(attack_data["damage"],attack_data["from_enemy"])
	

func damage_player(amount:int, from_enemy):
	if game_manager.player_resource.reflect > 0:#if player has reflect
		#hit enemy back for amount
		var reflect_amount:int
		var current_reflect:int = game_manager.player_resource.reflect
		if from_enemy != null:
			if current_reflect > amount:
				game_manager.player_resource.reflect -= amount
				reflect_amount = amount
			else:
				game_manager.player_resource.reflect = 0
				reflect_amount = game_manager.player_resource.reflect
			from_enemy.deal_damage(reflect_amount)
		
	if game_manager.player_resource.shield > 0:#if player has shield
		if game_manager.player_resource.shield > amount:
			game_manager.player_resource.shield -= amount
		else:
			amount -= game_manager.player_resource.shield
			game_manager.player_resource.shield = 0
			game_manager.player_resource.health -= amount
	
	else:
		game_manager.player_resource.health -= amount
	
	if game_manager.player_resource.health <= 0:
		end_battle(false)
	
	vitals_changed.emit()


func update_vitals():
	
	ui_hp.text = var_to_str(game_manager.player_resource.health)
	ui_shield.text =var_to_str(game_manager.player_resource.shield)
	
	

func reset_player_attack():
	player_attack = {
	"damage":0,
	"reflect":0,
	"shield":0,
	"heal":0,
	"gold":0,
	"status_conditions":[],
	"elements":[],
	"element_damage":[]
	}

func update_player_target(new_target:Enemy):
	if player_target != null:
		player_target.show_arrow(false)
		#player_target.manage_current_player_dmg("reset",null)
	player_target = new_target
	player_target.show_arrow(true)
	#player_target.manage_current_player_dmg("set",player_attack["damage"])
	calc_player_attack()
	print("current target is: ", player_target.name)

func do_positive_statuses():#also does positive effects
	var manip_statuses:Array[Status_Library.StatusCondition] = player_attack["status_conditions"].duplicate()
	for status in player_attack["status_conditions"]:
		var status_ref = game_manager.status_lib.get_status_data(status)
		if status_ref["is_positive"]:
			print("status ", status, " is positive so doing NOW")
			match status:
				Status_Library.StatusCondition.CURE:
					#cure all negitive effects
					cure_negative_effects()
				Status_Library.StatusCondition.REFLECT:
					game_manager.player_resource.reflect += game_manager.player_resource.attack
				_:
					pass
			add_status_conditions(status)
			#remove from send attack
			var status_index:int = manip_statuses.find(status)
			manip_statuses.remove_at(status_index)
	player_attack["status_conditions"] = manip_statuses
	
	
	
func add_status_conditions(value):
	if typeof(value) != TYPE_ARRAY:
		var status_ref = game_manager.status_lib.get_status_data(value)
		status_conditions.append(value)
		status_timeout.append(status_ref["turns"])
		
#		print("statuses is now: ",  status_conditions)
#		print("status timeout is now: ",  status_timeouts)
		
		if spawned_statuses.find(value) == -1:
			spawned_statuses.append(value)
			var next_ui_status = game_manager.status_lib.status_prefab.instantiate()
			status_grid.add_child(next_ui_status)
			next_ui_status.setup_status(status_ref)
			
		print(name, " adding statuses is now: ",  status_conditions)
		print(name, " adding status timeout is now: ",  status_timeout)
		
func do_status_effects():
	var condition_index:int
	for status in status_conditions:
		#do status stuff ADD DMG Here
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
				
				
				
		if status != -1:
			var status_ref = game_manager.status_lib.get_status_data(status)
			damage_player(status_ref["damage"],null)
		#minus 1 from timeout 
		if status_timeout[condition_index] > 1:
			status_timeout[condition_index] -=1
		elif status == Status_Library.StatusCondition.REFLECT:
			pass
		else:
			#var remove_index = status_conditions.find(status)
			#print("condition index sanity check it : ",condition_index)
			status_conditions.pop_at(condition_index)
			status_timeout.pop_at(condition_index)
			status_conditions.insert(condition_index,-1)
			status_timeout.insert(condition_index,0)
			
			
			#print(name, ": statuses is now: ",  status_conditions)
			#print(name, ": status timeout is now: ",  status_timeout)
		condition_index+=1
	
	update_statuses()
	clean_up_statuses()
	
	
func clean_up_statuses():
	#var status_index:int
	var clean_status:Array[Status_Library.StatusCondition]
	var clean_timeout:Array[int]
	
	for status in status_conditions:
		print("sanity check status = ", status)
		if status != -1:
			clean_status.append(status)
			clean_timeout.append(status_timeout[status_conditions.find(status)])
	
	status_conditions = clean_status
	status_timeout = clean_timeout
	
	print(name, ": statuses is now: ",  status_conditions)
	print(name, ": status timeout is now: ",  status_timeout)
	
func update_statuses():
	for status_container in status_grid.get_children():
		status_container.update_status()
		
func cure_negative_effects():
	for status in status_conditions:
		var status_ref = game_manager.status_lib.get_status_data(status)
		if !status_ref["is_positive"]:
			var status_index = status_conditions.find(status)
			status_conditions[status_index] = -1
			status_timeout[status_index] = 0
			
	clean_up_statuses()

func end_battle(win:bool):
	if win:
		print("game continues: ", reward)
		var dice_array:Array[Dictionary]
		#RESOLVE player win Gold/Dice/Item
		if typeof(reward) == TYPE_INT:
			game_manager.player_resource.gold += reward
		else:
			for i in game_manager.rng.randi_range(1,3):
				var picked_dice = game_manager.dice_lib.all_dice.values().pick_random()
				dice_array.append(picked_dice)
				if game_manager.default_checker(picked_dice):
					game_manager.player_resource.getset_dice_deck("add",{
						"default":true,
						"dice_name":picked_dice["item_name"]
						})
				else:
					game_manager.player_resource.getset_dice_deck("add",picked_dice)
			
		var ui_summary = game_manager.ui_battle_summary.instantiate()
		ui_summary.setup_summary({
			"enemies":enemy_count,
			"reward":reward,
			"dice":dice_array
			})
			
		print("player gold is now: ", game_manager.player_resource.gold)
		add_child(ui_summary)
		#queue_free()
		#$"../..".manage_camera("map_reset")
	else:
		print("game end")

func summary_complete():
	$"../..".manage_camera("map_reset")
	queue_free()

