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

func _ready():
	enemy_lib = preload("res://Resources/enemies/enemy_library.tres")
	current_dice_deck = GameManager.player_resource.getset_dice_deck("get", null)
	battle_data = [
		enemy_lib.get_enemy_resource("bat"),
		enemy_lib.get_enemy_resource("slime"),
		enemy_lib.get_enemy_resource("wolf")]
	
	setup_enemies()
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
