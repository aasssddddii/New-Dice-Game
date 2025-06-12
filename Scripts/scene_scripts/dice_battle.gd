extends Node2D

signal vitals_changed
signal deck_changed(dice_deck:Array[Dictionary],discard_deck:Array[Dictionary])

@onready var player_hand = $player_hand_container
@onready var dice_layer = $dice_layer
@onready var action_slots = $action_slot_container
@onready var enemy_spawns = $enemy_spawns
@onready var enemy_layer = $enemy_layer
@onready var status_grid = $player_layer/player/status_conditions
@onready var charm_grid = $battle_charm/PanelContainer/ScrollContainer/charm_display
@onready var dice_lib = preload("res://Resources/dice_library.tres")
#var enemy_lib #= preload("res://Resources/enemies/enemy_library.tres")
@onready var action_slot_prefab = preload("res://Prefabs/game_ui/action_slot.tscn")
@onready var player_hand_slot_prefab = preload("res://Prefabs/game_ui/player_hand_slot.tscn")
@export var ui_item_description:ColorRect

var current_dice_deck:Array[Dictionary]
var discard:Array[Dictionary]
var battle_data:Array[Resource]
var game_manager = GameManager

var status_conditions:Array[Status_Library.StatusCondition]
var status_timeout:Array[int]
signal status_changed(status_conditions:Array[Status_Library.StatusCondition])

var current_enemy_dmg:int

var player_target:Enemy

var spawned_statuses:Array[Status_Library.StatusCondition]

var reward

var is_trap_battle:bool = false
var trap_disarmed:bool = false

#ui
@onready var ui_hp = $player_layer/player/VBoxContainer/ui_hp/ui_text
@onready var ui_shield = $player_layer/player/VBoxContainer/ui_shield/ui_text
@onready var ui_damage = $player_ui/ui_damage
@onready var cancel_item_button = $player_ui/cancel_item_button
#calc
@onready var ui_calc_hp = $player_layer/player/calc_hp
@onready var ui_calc_defend = $player_layer/player/calc_defend

var can_attack:bool = true
var enemy_count:int

var coconut_doubler:int = 0
var heal_power_up:int = 0

var action_up_timers:Array[int]

#Staticly set battle need to get ready for map generation
func setup_dice_batle(input_data:Dictionary):
	current_dice_deck = game_manager.player_resource.getset_dice_deck("get", null)
		
	battle_data = input_data["enemies"]
	if battle_data[0].enemy_name == "trap":
		is_trap_battle = true
	
	
	reward = input_data["reward"]
#	for ui_slot in action_slots.get_children():
#		ui_slot.get_child(0).action_slot_filled.connect(calc_player_attack)
#		ui_slot.get_child(0).action_slot_unfilled.connect(calc_player_attack)
	
	#show player GUI
	setup_player_gui()
	show_player_menu()
	
	#setup player
	update_vitals()
	vitals_changed.connect(update_vitals)
	show_charms()
	
	
	
	
	
	setup_enemies()
	update_player_target(enemy_layer.get_child(0))
	call_deferred("set_player_hand")


func show_charms():
	charm_grid.setup_inventory(game_manager.player_resource.charm_inventory,"battle_charm")
	
func show_player_menu():
	$player_ui.setup_player_menu()

func setup_enemies():
	if !is_trap_battle:
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
	else:
		var next_enemy = game_manager.enemy_lib.trap_prefab.instantiate()
		next_enemy.position = enemy_spawns.get_child(0).position - Vector2(0,20)
		enemy_layer.add_child(next_enemy)
		next_enemy.setup_enemy(game_manager.enemy_lib.trap_enemy_resource)

func setup_player_gui():
#	for i in 3:#Hard coded for testing ACTUAL will be from player resource
#		var next_action_slot = action_slot_prefab.instantiate()
#		next_action_slot.get_child(0).action_slot_filled.connect(calc_player_attack)
#		next_action_slot.get_child(0).action_slot_unfilled.connect(calc_player_attack)
#		action_slots.add_child(next_action_slot)
	for i in 5:#Hard coded for testing ACTUAL will be from player resource
		var next_player_hand_slot = player_hand_slot_prefab.instantiate()
		player_hand.add_child(next_player_hand_slot)
	pass

func add_dice_to_hand(die_to_add:Dictionary):
	var next_player_hand_slot = player_hand_slot_prefab.instantiate()
	player_hand.add_child(next_player_hand_slot)
	call_deferred("add_dice_to_new_hand_slot",next_player_hand_slot,die_to_add)

func add_dice_to_new_hand_slot(next_player_hand_slot,die_to_add):
	var next_dice = dice_lib.dice_prefab.instantiate()
	next_dice.scale = Vector2(.7,.7)
	next_dice.set_dice_data(die_to_add)
	next_dice.name = die_to_add["item_name"]
	dice_layer.add_child(next_dice)
	print("dice going to position: ", next_player_hand_slot.global_position, " slot name: ", next_player_hand_slot.name)
	next_dice.ui_item_description = ui_item_description
	next_dice.global_position = next_player_hand_slot.global_position #+ Vector2(9,9)
	next_dice.last_snap_area = next_player_hand_slot.get_child(0)
	organize_dice()
	
func add_action_up_slot():
	var next_action_slot = action_slot_prefab.instantiate()
	next_action_slot.get_child(0).action_slot_filled.connect(calc_player_attack)
	next_action_slot.get_child(0).action_slot_unfilled.connect(calc_player_attack)
	action_slots.add_child(next_action_slot)
	action_up_timers.append(3)
	
	
func reset_action_slots():
	for slot in action_slots.get_children():
		slot.queue_free()
	for i in game_manager.player_resource.action_size + action_up_timers.size():
		var next_action_slot = action_slot_prefab.instantiate()
		next_action_slot.get_child(0).action_slot_filled.connect(calc_player_attack)
		next_action_slot.get_child(0).action_slot_unfilled.connect(calc_player_attack)
		action_slots.add_child(next_action_slot)

func action_timer_stepper():
	for action_timer_index in action_up_timers.size():
		if action_up_timers[action_timer_index]> 0:
			action_up_timers[action_timer_index] -= 1
		if action_up_timers[action_timer_index] <= 0:
			action_up_timers.remove_at(action_up_timers.find(action_up_timers[action_timer_index]))
	#print("action up timers now: ", action_up_timers)

func organize_dice():
	for die in dice_layer.get_children():
		die.go_to_last_snap()

func rehand_dice():
	for slot in action_slots.get_children():
		if slot.get_child(0).is_filled:
			var moving_dice = slot.get_child(0).filled_node
			var move_to
			for player_slot in player_hand.get_children():
				if !player_slot.get_child(0).is_filled:
					move_to = player_slot.get_child(0)
			moving_dice.snap_area = move_to
			moving_dice.go_to_last_snap()
			move_to.is_filled = true
			move_to.filler(moving_dice)

func set_player_hand():
	#SETS ACTIONS SLOTSVVV
	reset_action_slots()
	#print("total hand size right now: ", player_hand.get_children())
	var hand_slots_not_filled = player_hand.get_children().filter(func(slot):return !slot.get_child(0).is_filled)
	#print("not filled player slot check: ", hand_slots_not_filled)
	
	for slot in hand_slots_not_filled:
		if current_dice_deck.size() < 1:
			shuffle_deck()
			
			var next_dice = dice_lib.dice_prefab.instantiate()
			next_dice.scale = Vector2(.7,.7)
			var next_dice_data = current_dice_deck.pick_random()
			current_dice_deck.remove_at(current_dice_deck.find(next_dice_data))
			#filters out default dice
			if next_dice_data.has("default"):
				#print("setting up dice: ", dice_lib.get_dice_data(next_dice_data["item_name"]))
				next_dice.set_dice_data(dice_lib.get_dice_data(next_dice_data["item_name"]))#dice library reference
			else:
				next_dice.set_dice_data(next_dice_data)
				
			next_dice.name = next_dice_data["item_name"]
			dice_layer.add_child(next_dice)
			next_dice.ui_item_description = ui_item_description
			next_dice.global_position = slot.global_position + Vector2(9,9)
			next_dice.last_snap_area = slot.get_child(0)
			#next_dice.go_to_last_snap()
		else:
			var next_dice = dice_lib.dice_prefab.instantiate()
			next_dice.scale = Vector2(.7,.7)
			var next_dice_data = current_dice_deck.pick_random()
			current_dice_deck.remove_at(current_dice_deck.find(next_dice_data))
			if next_dice_data.has("default"):
				#print("setting up dice: ", dice_lib.get_dice_data(next_dice_data["item_name"]))
				next_dice.set_dice_data(dice_lib.get_dice_data(next_dice_data["item_name"]))#dice library reference
			else:
				next_dice.set_dice_data(next_dice_data)
				
			next_dice.name = next_dice_data["item_name"]
			dice_layer.add_child(next_dice)
			next_dice.ui_item_description = ui_item_description
			next_dice.global_position = slot.global_position + Vector2(9,9)
			next_dice.last_snap_area = slot.get_child(0)
			
	
	deck_changed.emit(current_dice_deck,discard)
	display_player_calc()

func shuffle_deck():
	current_dice_deck += discard
	#print("adding discard: ", discard)
	discard.clear()
	
	current_dice_deck.shuffle()
	#print("current deck after shuffle: ", current_dice_deck)

func use_dice(dice_array:Array[Dice]):
	#Send Player Attack Data Here
	for die in dice_array:
		if !die == null:
			var dice_data = die.dice_data
			
			
			discard.append(dice_data)
			die.queue_free()
		
	set_player_hand()


func discard_dice(die_to_discard):
	discard.append(die_to_discard.dice_data)
	die_to_discard.queue_free()


func trap_check(input):
	
	var dice_sequence:Array[Dice.DiceType]
	for die in input:
		if !die == null:
			dice_sequence.append(die.dice_data["type"])
		else:
			dice_sequence.append(Dice.DiceType.NONE)
	
	if dice_sequence == enemy_layer.get_child(0).trap_key:
		#print("TRAP DISARMED")
		trap_disarmed = true
		end_battle(true)
	#print("used dice: ",dice_sequence, " check against key: ", enemy_layer.get_child(0).trap_key)

func disarm_trap():
	#print("TRAP DISARMED")
	trap_disarmed = true
	end_battle(true)

#Player ENDS turn here
func _on_submit_button_down():
	if can_attack:
		can_attack = false
		action_timer_stepper()
		$player_ui/submit_button.modulate = Color.SADDLE_BROWN
		var send_dice:Array[Dice]
		for slot in action_slots.get_children():
			var slot_area = slot.get_child(0)
			if slot_area.is_filled:
				var dice_node = slot_area.filled_node
				send_dice.append(dice_node)
			else:
				send_dice.append(null)
				
		
		
		if is_trap_battle:
			#CHECK FOR TRAP KEY HERE SINCE I HAVE ALL DICE here
			trap_check(send_dice)
		
		
		clean_up_player_hand()
		#^^^^THIS IS WERE RESETTING THE HAND GUI should go^^^^
		call_deferred("use_dice",send_dice)
		#use_dice(send_dice)
		
		do_positive_statuses()#does positive statuses
		#print("sending attack: ", player_attack)
		#evaluate player specific data
		
#		game_manager.player_resource.gold += player_attack["gold"]
#		print("player gained ", player_attack["gold"], " gold")
#
#		game_manager.player_resource.shield += player_attack["shield"]
#		game_manager.player_resource.health += player_attack["heal"]
		manage_positive_player_attack(player_attack["heal"],player_attack["shield"],player_attack["gold"])
		player_target.hit_enemy(player_attack)
		coconut_doubler = 0
		reset_player_attack()
		
		vitals_changed.emit()
		await get_tree().create_timer(.7).timeout
		

		do_status_effects()
		#clean_up_statuses()
		take_enemy_turn()
		current_enemy_dmg = calc_enemy_dmg()
		calc_player_attack()
		#print("total enemy attack: ", current_enemy_dmg)

	else:
		print("not player turn yet...")

func clean_up_player_hand():
	if player_hand.get_children().size() >= game_manager.player_resource.hand_size:
		#print("more filled than hand size")
		for child in player_hand.get_children():
			if player_hand.get_children().size() > game_manager.player_resource.hand_size:
				if !child.get_child(0).is_filled:
					child.reparent(game_manager,true)
					child.queue_free()
					#await child.tree_exited
		call_deferred("organize_dice")
#	else:
#		print("less filled than hand size")
#		pass


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
	var calculator_ls_heal:int
	var calculator_gold:int
	var calculator_statuses:Array[Status_Library.StatusCondition]
	var calculator_elements:Array[Dice.DamageElement]
	var calculator_element_dmg:Array[int]
	var all_dice_bonus:bool = false
	#var action_slots_node = $action_slot_container
	
	action_slots.modulate = Color.WHITE
	#Size needed for some reason
	if action_slot_dice.size() == action_slots.get_children().size() && action_slot_dice.all(func(element): return element.dice_data["type"] == action_slot_dice[0].dice_data["type"]):
		all_dice_bonus = true
		action_slots.modulate = Color.GOLD
	#print("all dice bonus is now: ", all_dice_bonus)
	#Rage potion
	var atk_buff:int = 0
	if status_conditions.has(Status_Library.StatusCondition.ATKBUFF):
		atk_buff = game_manager.player_resource.attack * status_conditions.count(Status_Library.StatusCondition.ATKBUFF)
	var heal_buff:int = 0
	if status_conditions.has(Status_Library.StatusCondition.HEALBUFF):
		heal_buff = game_manager.player_resource.heal_power * status_conditions.count(Status_Library.StatusCondition.HEALBUFF)
		
	var defend_buff:int = 0
	if status_conditions.has(Status_Library.StatusCondition.DEFBUFF):
		defend_buff = game_manager.player_resource.defend * status_conditions.count(Status_Library.StatusCondition.DEFBUFF)
	#print("calculating value based on slot data: ", action_slot_dice)
	for die in action_slot_dice:
		if die.up_face >= 1:
			#print("calculating next die: ", die.name)
			var die_data = die.dice_data
			var upgraded_player_attack = (game_manager.player_resource.attack + atk_buff) * die.up_face
			var upgraded_player_heal = (game_manager.player_resource.heal_power + heal_buff) * die.up_face
			var upgraded_player_defend = (game_manager.player_resource.defend + defend_buff) * die.up_face
			
			match die_data["type"]:
				Dice.DiceType.ATTACK:
					if all_dice_bonus:
						calculator_damage += upgraded_player_attack * game_manager.player_resource.all_dice_bonus
					else:
						calculator_damage += upgraded_player_attack
				Dice.DiceType.DEFEND:
					if all_dice_bonus:
						calculator_defend += upgraded_player_defend * game_manager.player_resource.all_dice_bonus
					else:
						calculator_defend += upgraded_player_defend
				Dice.DiceType.REROLL:
					pass
				Dice.DiceType.BLEED:
					if calculator_statuses.find(Status_Library.StatusCondition.BLEED) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.BLEED)
					var base_dmg = (upgraded_player_attack*.75)
						
					if all_dice_bonus:
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.BLEED]:
							calculator_damage += base_dmg/2 * game_manager.player_resource.all_dice_bonus
						else:
							calculator_damage += base_dmg * game_manager.player_resource.all_dice_bonus
					else:
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.BLEED]:
							calculator_damage += base_dmg/2
						else:
							calculator_damage += base_dmg
				Dice.DiceType.HEAL:
					if all_dice_bonus:
						calculator_heal += upgraded_player_heal * game_manager.player_resource.all_dice_bonus
					else:
						calculator_heal += upgraded_player_heal
				Dice.DiceType.GOLD:
					if all_dice_bonus:
						calculator_damage +=  2
						calculator_gold += 2 + die.up_face - 1
					else:
						calculator_damage += 1 
						calculator_gold += 1 + die.up_face - 1
				Dice.DiceType.REFLECT:
					if all_dice_bonus:
						for i in die.up_face:
							calculator_statuses.append(Status_Library.StatusCondition.REFLECT)
							calculator_statuses.append(Status_Library.StatusCondition.REFLECT)
					else:
						for i in die.up_face:
							calculator_statuses.append(Status_Library.StatusCondition.REFLECT)
				Dice.DiceType.LIFESTEAL:
					var base_dmg = upgraded_player_attack
					if all_dice_bonus:
						calculator_damage += base_dmg * game_manager.player_resource.all_dice_bonus
						if upgraded_player_heal > base_dmg:
							calculator_ls_heal += base_dmg
						else:
							calculator_ls_heal += upgraded_player_heal
					else:
						calculator_damage += base_dmg
						#need to take enemy HP into account
						if upgraded_player_heal > base_dmg/2:
							calculator_ls_heal += base_dmg/2
						else:
							calculator_ls_heal += upgraded_player_heal
				Dice.DiceType.POISON:
					var base_dmg = (upgraded_player_attack /2)
					if all_dice_bonus:
						calculator_statuses.append(Status_Library.StatusCondition.POISON)
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.POISON]:
							calculator_damage += (base_dmg/2) * game_manager.player_resource.all_dice_bonus
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.POISON]:
							calculator_damage += upgraded_player_attack * game_manager.player_resource.all_dice_bonus
						else:
							calculator_damage += base_dmg * game_manager.player_resource.all_dice_bonus
					else:
						if calculator_statuses.find(Status_Library.StatusCondition.POISON) == -1:
							calculator_statuses.append(Status_Library.StatusCondition.POISON)
							
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.POISON]:
							calculator_damage += base_dmg/2
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.POISON]:
							calculator_damage += base_dmg * 1.5
						else:
							calculator_damage += base_dmg
				Dice.DiceType.CURE:
					#6/6 Need to come back after I fix Status conditions
					#I want to add a full heal when die face is over 1
					if calculator_statuses.find(Status_Library.StatusCondition.CURE) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.CURE)
				Dice.DiceType.DISARM:
					if all_dice_bonus:
						calculator_damage += 2
					else:
						calculator_damage += 1
					if calculator_statuses.find(Status_Library.StatusCondition.DISARM) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.DISARM)
				Dice.DiceType.STUN:
					if all_dice_bonus:
						calculator_damage += 2
					else:
						calculator_damage += 1
					if calculator_statuses.find(Status_Library.StatusCondition.STUN) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.STUN)
				#I want to add longer timers for all dice bonus on buffs
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
				#--------------------------------------------------------
				Dice.DiceType.FIRE:
					var element_dmg:int
					var base_dmg = (upgraded_player_attack*.5)
					#calculator_damage += (game_manager.player_resource.attack /2)
					if all_dice_bonus:
						if calculator_statuses.find(Status_Library.StatusCondition.BURN) == -1:
							calculator_statuses.append(Status_Library.StatusCondition.BURN)
							
							
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.FIRE]:
							calculator_damage += (upgraded_player_attack * game_manager.player_resource.all_dice_bonus)/2
							element_dmg= (upgraded_player_attack * game_manager.player_resource.all_dice_bonus)/2
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.FIRE]:
							calculator_damage += upgraded_player_attack * game_manager.player_resource.all_dice_bonus
							element_dmg= upgraded_player_attack * game_manager.player_resource.all_dice_bonus
						else:
							calculator_damage += upgraded_player_attack
							element_dmg= upgraded_player_attack
					else:
						if calculator_statuses.find(Status_Library.StatusCondition.BURN) == -1:
							calculator_statuses.append(Status_Library.StatusCondition.BURN)
							
							
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.FIRE]:
							calculator_damage += base_dmg/2
							element_dmg= base_dmg/2
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.FIRE]:
							calculator_damage += upgraded_player_attack
							element_dmg= upgraded_player_attack
						else:
							calculator_damage += base_dmg
							element_dmg= base_dmg
						
					if calculator_elements.find(Dice.DamageElement.FIRE) == -1:
						calculator_elements.append(Dice.DamageElement.FIRE)
						calculator_element_dmg.append(element_dmg)
					else:
						var index = calculator_elements.find(Dice.DamageElement.FIRE)
						calculator_element_dmg[index] += element_dmg
				Dice.DiceType.ICE:#need to add % chance to freeze
					var element_dmg:int
					var base_dmg = (upgraded_player_attack*.5)
					
					if all_dice_bonus:
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.ICE]:
							calculator_damage += (upgraded_player_attack * game_manager.player_resource.all_dice_bonus)/2
							element_dmg= (upgraded_player_attack * game_manager.player_resource.all_dice_bonus)/2
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.ICE]:
							calculator_damage += upgraded_player_attack * game_manager.player_resource.all_dice_bonus
							element_dmg= upgraded_player_attack * game_manager.player_resource.all_dice_bonus
						else:
							calculator_damage += upgraded_player_attack
							element_dmg= upgraded_player_attack
					else:
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.ICE]:
							calculator_damage += base_dmg/2
							element_dmg= base_dmg/2
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.ICE]:
							calculator_damage += upgraded_player_attack
							element_dmg= upgraded_player_attack
						else:
							calculator_damage += base_dmg
							element_dmg= base_dmg
					
					
					if calculator_elements.find(Dice.DamageElement.ICE) == -1:
						calculator_elements.append(Dice.DamageElement.ICE)
						calculator_element_dmg.append(element_dmg)
					else:
						var index = calculator_elements.find(Dice.DamageElement.ICE)
						calculator_element_dmg[index] += element_dmg
						
					#chance to freeze
					if game_manager.rng.randi_range(1,20) > 1:#18:
						if calculator_statuses.find(Status_Library.StatusCondition.FROZEN) == -1:
							calculator_statuses.append(Status_Library.StatusCondition.FROZEN)
						
				Dice.DiceType.LIGHTNING:
					var element_dmg:int
					var base_dmg:int = (upgraded_player_attack*.5)
					if all_dice_bonus:
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.LIGHTNING]:
							calculator_damage += upgraded_player_attack/2
							element_dmg=upgraded_player_attack/2
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.LIGHTNING]:
							calculator_damage += upgraded_player_attack * game_manager.player_resource.all_dice_bonus
							element_dmg= upgraded_player_attack * game_manager.player_resource.all_dice_bonus
						else:
							calculator_damage += upgraded_player_attack
							element_dmg= upgraded_player_attack
					else:
						if player_target.current_enemy_resource.resistantses[Dice.DamageElement.LIGHTNING]:
							calculator_damage += base_dmg/2
							element_dmg= base_dmg/2
						elif player_target.current_enemy_resource.weaknesses[Dice.DamageElement.LIGHTNING]:
							calculator_damage += upgraded_player_attack
							element_dmg= upgraded_player_attack
						else:
							calculator_damage += base_dmg
							element_dmg= base_dmg
					
					
					
					
					if calculator_elements.find(Dice.DamageElement.LIGHTNING) == -1:
						calculator_elements.append(Dice.DamageElement.LIGHTNING)
						calculator_element_dmg.append(element_dmg)
					else:
						var index = calculator_elements.find(Dice.DamageElement.LIGHTNING)
						calculator_element_dmg[index] += element_dmg
						
						
	if player_target != null:
		#print("checking enemy hp: ", player_target.current_enemy_resource.health, " against calc ls heal: ", calculator_ls_heal)
		if calculator_ls_heal > player_target.current_enemy_resource.health:
			calculator_ls_heal = player_target.current_enemy_resource.health
			
	for i in coconut_doubler:
		calculator_damage*=2
		
	player_attack = {
	"damage":calculator_damage,
	"reflect":calculator_reflect,
	"shield":calculator_defend,
	"heal":calculator_heal,
	"ls_heal":calculator_ls_heal,
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
	var player_heal = player_attack["heal"] + player_attack["ls_heal"]
	
	if player_heal > 0:
		ui_calc_hp.text = "+"+var_to_str(player_heal)
#	else:
#		ui_calc_hp.text = var_to_str(player_attack["heal"])
	if player_attack["shield"] >0:
		ui_calc_defend.text = "+"+var_to_str(player_attack["shield"])
#	else:
#		ui_calc_defend.text = var_to_str(player_attack["shield"])
	
	
	
	#ZERO Checking
	if player_attack["shield"] <=0:
		ui_calc_defend.visible = false
	else:
		ui_calc_defend.visible = true
	if player_heal <= 0:
		ui_calc_hp.visible = false
	else:
		ui_calc_hp.visible = true

func update_damage():
	#print("sanity check player damage: ",player_attack["damage"])
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
		
		
	#do_status_effects()
	
	current_enemy_dmg = calc_enemy_dmg()
	calc_player_attack()
	can_attack = true
	$player_ui/submit_button.modulate = Color.WHITE
	



func hit_player(attack_data:Dictionary):
	#print("player takes ", attack_data["damage"]," damage")
	#print("adding status effect to player: ", attack_data["status_effect"])
	if !status_conditions.has(Status_Library.StatusCondition.PROTECT):
		if status_conditions.has(Status_Library.StatusCondition.SMOKE):
			if game_manager.rng.randi_range(1,20) > (5 * (1*status_conditions.count(Status_Library.StatusCondition.SMOKE))):#attack goes through check
				if attack_data["status_effect"] != Status_Library.StatusCondition.NONE:
					add_status_conditions(attack_data["status_effect"])
				
				damage_player(attack_data["damage"],attack_data["from_enemy"],false)
		else:
			if attack_data["status_effect"] != Status_Library.StatusCondition.NONE:
				add_status_conditions(attack_data["status_effect"])
			
			damage_player(attack_data["damage"],attack_data["from_enemy"],false)
		


func damage_player(amount:int, from_enemy, direct_damage:bool):
	if game_manager.player_resource.reflect > 0:#if player has reflect
		#hit enemy back Reflect
		var reflect_amount:int
		var current_reflect:int = game_manager.player_resource.reflect
		if from_enemy != null:
			if current_reflect > amount:
				game_manager.player_resource.reflect -= amount
				reflect_amount = amount
			else:
				game_manager.player_resource.reflect = 0
				reflect_amount = game_manager.player_resource.reflect
			from_enemy.deal_damage(reflect_amount, false)
	
	if !direct_damage:
		#if player has shield
		if game_manager.player_resource.shield > 0:
			if game_manager.player_resource.shield > amount:
				game_manager.player_resource.shield -= amount
			else:
				amount -= game_manager.player_resource.shield
				game_manager.player_resource.shield = 0
				game_manager.player_resource.health -= amount
		else:
			game_manager.player_resource.health -= amount
	else:
		game_manager.player_resource.health -= amount
	
	#Kill check
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
	"ls_heal":0,
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
	#print("current target is: ", player_target.name)

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

		if spawned_statuses.find(value) == -1:
			spawned_statuses.append(value)
			var next_ui_status = game_manager.status_lib.status_prefab.instantiate()
			status_grid.add_child(next_ui_status)
			next_ui_status.setup_status(status_ref)
			
		print(name, " adding statuses is now after ADD: ",  status_conditions)
		print(name, " adding status timeout is now after ADD: ",  status_timeout)
		status_changed.emit(status_conditions)
		
func do_status_effects():
	var condition_index:int
	for status in status_conditions.duplicate():
		#do status stuff ADD DMG Here
#		match status:
#			Status_Library.StatusCondition.BLEED:
#				pass
#			Status_Library.StatusCondition.REFLECT:
#				pass
#			Status_Library.StatusCondition.DISARM:
#				pass
#			Status_Library.StatusCondition.STUN:
#				pass
#			Status_Library.StatusCondition.POISON:
#				pass
#			Status_Library.StatusCondition.FROZEN:
#				pass
#			Status_Library.StatusCondition.ATKBUFF:
#				pass
#			Status_Library.StatusCondition.ATKDEBUFF:
#				pass
#			Status_Library.StatusCondition.DEFBUFF:
#				pass
#			Status_Library.StatusCondition.DEFDEBUFF:
#				pass
#			Status_Library.StatusCondition.CURE:
#				pass
#			Status_Library.StatusCondition.BURN:
#				pass
		if status != -1:
			var status_ref = game_manager.status_lib.get_status_data(status)
			if status_ref["name"] == "bleed" || status_ref["name"] == "poison":
				damage_player(status_ref["damage"],null, true)
			else:
				damage_player(status_ref["damage"],null, false)
		#minus 1 from timeout 
		if status_timeout[condition_index] > 1:
			status_timeout[condition_index] -=1
		elif status == Status_Library.StatusCondition.REFLECT:
			pass
		else:
			#var remove_index = status_conditions.find(status)
			print("removing condition at condition index sanity check it : ",condition_index)
			status_conditions.remove_at(condition_index)
			status_timeout.remove_at(condition_index)
			status_changed.emit(status_conditions)
			condition_index-=1
		condition_index+=1
	print(name, ": statuses is now after DO: ",  status_conditions)
	print(name, ": status timeout is now after DO: ",  status_timeout)
	update_statuses()
	#clean_up_statuses()
	
	
#func clean_up_statuses():
#	#var status_index:int
#	var clean_status:Array[Status_Library.StatusCondition]
#	var clean_timeout:Array[int]
#
#	for status in status_conditions:
#		print("sanity check status = ", status)
#		if status != -1:
#			clean_status.append(status)
#			clean_timeout.append(status_timeout[status_conditions.find(status)])
#
#	status_conditions = clean_status
#	status_timeout = clean_timeout
	
	#print(name, ": statuses is now: ",  status_conditions)
	#print(name, ": status timeout is now: ",  status_timeout)
	
func update_statuses():
	for status_container in status_grid.get_children():
		status_container.update_status()
		
func cure_negative_effects():
	for status in status_conditions.duplicate():
		var status_ref = game_manager.status_lib.get_status_data(status)
		if !status_ref["is_positive"]:
			var status_index = status_conditions.find(status)
			status_conditions.remove_at(status_index)
			status_timeout.remove_at(status_index)
			print("removing status at: ", status_index)
			print(name, ": statuses is now: ",  status_conditions)
			print(name, ": status timeout is now: ",  status_timeout)
			
	update_statuses()

func end_battle(win:bool):
	if win && !is_trap_battle:
		#print("game continues: ", reward)
		#set player inventory
		game_manager.player_resource.getset_inventory("set",$player_ui/item_background/battle_item_container.inventory_data+game_manager.player_resource.getset_inventory("get_map",null))
		
		
		var dice_array:Array[Dictionary]
		#RESOLVE player win Gold/Dice/Item
		if typeof(reward) == TYPE_INT:
			game_manager.player_resource.gold += reward
		else:
			for i in game_manager.rng.randi_range(1,3):
				var picked_dice = game_manager.dice_lib.all_dice.values().pick_random()
				dice_array.append(picked_dice)
				game_manager.player_resource.getset_inventory("add",picked_dice)
			
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
	elif win && is_trap_battle:
	#	if game_manager.player_resource.health > 0:
		game_manager.player_resource.getset_inventory("set",$player_ui/item_background/battle_item_container.inventory_data+game_manager.player_resource.getset_inventory("get_map",null))
		
		
		#var dice_array:Array[Dictionary]
		var trap_gold = game_manager.enemy_lib.trap_enemy_resource.reward_gold
		
		
		if trap_disarmed:
			game_manager.player_resource.gold += trap_gold
		else:
			reward = 0
			
		var ui_summary = game_manager.ui_battle_summary.instantiate()
		ui_summary.setup_summary({
			"enemies":1,
			"reward":reward
			#"dice":dice_array
			})
			
		print("player gold is now: ", game_manager.player_resource.gold)
		add_child(ui_summary)
#		else:
#			print("game end")
	else:
		print("game end")

func summary_complete():
	#SETUP FOR NEXT SELECTION
	$"../choice_creator".poi_manager()
	queue_free()

func close_item_selections():
	start_fate_fragment(false)
	start_dictated_fate(false)

func start_fate_fragment(choice:bool):
	for slot in player_hand.get_children():
		slot.get_child(0).start_fate_fragment(choice)

func start_dictated_fate(choice:bool):
	for slot in player_hand.get_children():
		slot.get_child(0).start_dictated_fate(choice)

func rewind():
	for die in dice_layer.get_children():
		die.roll()
