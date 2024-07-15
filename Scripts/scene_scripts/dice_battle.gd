extends Node2D

@onready var player_hand = $player_hand
@onready var dice_layer = $dice_layer
@onready var action_slots = $action_slots
@onready var enemy_spawns = $enemy_spawns
@onready var enemy_layer = $enemy_layer
@onready var dice_lib = preload("res://Resources/dice_library.tres")
var enemy_lib #= preload("res://Resources/enemies/enemy_library.tres")

var current_dice_deck:Array[Dictionary]
var discard:Array[Dictionary]
var battle_data:Array[Resource]
var game_manager = GameManager

var status_conditions:Array[Status_Library.StatusCondition]
var status_timeout:Array[int]

var current_enemy_dmg:int

var player_target:Enemy

#ui
@onready var ui_hp = $player_layer/player/VBoxContainer/ui_hp/ui_text
@onready var ui_shield = $player_layer/player/VBoxContainer/ui_shield/ui_text
#calc
@onready var ui_calc_hp = $player_layer/player/calc_hp
@onready var ui_calc_defend = $player_layer/player/calc_defend



func _ready():
	enemy_lib = preload("res://Resources/enemies/enemy_library.tres")
	current_dice_deck = GameManager.player_resource.getset_dice_deck("get", null)
	battle_data = [
		enemy_lib.get_enemy_resource("bat"),
		enemy_lib.get_enemy_resource("slime"),
		enemy_lib.get_enemy_resource("wolf")]
		
	for ui_slot in action_slots.get_children():
		ui_slot.get_child(0).action_slot_filled.connect(calc_player_attack)
		ui_slot.get_child(0).action_slot_unfilled.connect(calc_player_attack)
	
	#setup player
	ui_hp.text = var_to_str(game_manager.player_resource.health)
	
	
	setup_enemies()
	update_player_target(enemy_layer.get_child(0))
	set_player_hand()


func setup_enemies():
	if battle_data != [null,null,null]:
		var enemy_counter:int
		for enemy in battle_data:
			var next_enemy = enemy_lib.enemy_prefab.instantiate()
			next_enemy.global_position = enemy_spawns.get_child(enemy_counter).global_position
			enemy_layer.add_child(next_enemy)
			next_enemy.setup_enemy(enemy)
			
			enemy_counter+=1
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


func shuffle_deck():
	current_dice_deck += discard
	#print("adding discard: ", discard)
	discard.clear()
	#print("current deck after shuffle: ", current_dice_deck)

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


func _on_submit_button_down():
	var send_dice:Array[Dice]
	for slot in action_slots.get_children():
		var slot_area = slot.get_child(0)
		if slot_area.is_filled:
			var dice_node = slot_area.filled_node
			send_dice.append(dice_node)
	use_dice(send_dice)
	print("sending attack: ", player_attack)
	player_target.hit_enemy(player_attack)
	reset_player_attack()
	
	
	
	
	take_enemy_turn()
	current_enemy_dmg = calc_enemy_dmg()
	calc_player_attack()
	#print("total enemy attack: ", current_enemy_dmg)


func calc_enemy_dmg():
	var enemy_calc_attack:int
	
	for enemy in enemy_layer.get_children():
		var enemy_attack_pattern = enemy.attack_pattern
		for attack in enemy_attack_pattern:
			if attack == enemy_resource.TurnActions.ATTACK:
				enemy_calc_attack += enemy.current_enemy_resource.attack
	#print("total enemy attack: ", enemy_calc_attack)
	return enemy_calc_attack


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
			#still need to calculate enemy resistances/weaknesses
			#still need to add all same bonus
			match die_data["type"]:
				Dice.DiceType.ATTACK:
					calculator_damage += game_manager.player_resource.attack
				Dice.DiceType.DEFEND:
					calculator_defend += game_manager.player_resource.defend
				Dice.DiceType.REROLL:
					pass
				Dice.DiceType.BLEED:
					pass
				Dice.DiceType.HEAL:
					calculator_heal += game_manager.player_resource.heal_power
				Dice.DiceType.GOLD:
					pass
				Dice.DiceType.REFLECT:
					pass
				Dice.DiceType.LIFESTEAL:
					pass
				Dice.DiceType.POISON:
					calculator_damage += (game_manager.player_resource.attack /2)
					if calculator_statuses.find(Status_Library.StatusCondition.POISON) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.POISON)
				Dice.DiceType.CURE:
					pass
				Dice.DiceType.DISARM:
					pass
				Dice.DiceType.STUN:
					calculator_damage += 1
					if calculator_statuses.find(Status_Library.StatusCondition.STUN) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.STUN)
				Dice.DiceType.ATKBUFF:
					pass
				Dice.DiceType.DEFBUFF:
					pass
				Dice.DiceType.ATKDEBUFF:
					pass
				Dice.DiceType.DEFDEBUFF:
					pass
				Dice.DiceType.FIRE:
					calculator_damage += (game_manager.player_resource.attack /2)
					if calculator_statuses.find(Status_Library.StatusCondition.BURN) == -1:
						calculator_statuses.append(Status_Library.StatusCondition.BURN)
				Dice.DiceType.ICE:
					pass
				Dice.DiceType.LIGHTNING:
					pass
	player_attack = {
	"damage":calculator_damage,
	"reflect":calculator_reflect,
	"shield":calculator_defend,
	"heal":calculator_heal-current_enemy_dmg,
	"gold":calculator_gold,
	"status_conditions":calculator_statuses,
	"elements":calculator_elements,
	"element_damage":calculator_element_dmg
	}
	#print("preparing to send attack: ", player_attack)
	display_player_calc()


func display_player_calc():
	if player_target != null:
		player_target.manage_current_player_dmg("set",player_attack["damage"])
		
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

func take_enemy_turn():
	for enemy in enemy_layer.get_children():
		#Do enemy Status
		enemy.do_status_effects()
		
		#Do Enemy Attack
		
		
		#setup next enemy attack
		enemy.setup_next_attack()

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
		player_target.manage_current_player_dmg("reset",null)
	player_target = new_target
	player_target.show_arrow(true)
	player_target.manage_current_player_dmg("set",player_attack["damage"])
	print("current target is: ", player_target.name)
