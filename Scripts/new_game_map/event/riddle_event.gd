extends Node2D

var game_manager = GameManager

@onready var submit_button = $player_ui/submit
@onready var text_box = $TextEdit
@onready var ui_riddle = $VBoxContainer/ui_riddle

@onready var riddle_result = $riddle_result
@onready var riddle_results_body = $riddle_result/VBoxContainer/ui_body
@onready var riddle_reward_label = $"riddle_result/VBoxContainer/reward label"
@onready var riddle_reward_grid = $riddle_result/VBoxContainer/GridContainer

var riddle_answers
var correct:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	submit_button.visible = false
	riddle_result.visible = false
	pass # Replace with function body.


func _on_text_edit_text_changed():
	if text_box.text != "":
		submit_button.visible = true
	else:
		submit_button.visible = false

func setup_riddle(riddle_data:Dictionary):
	ui_riddle.text = riddle_data["riddle"]
	riddle_answers = riddle_data["answers"]
	
	
	
	
func evaluate_answer(input_text:String):
	var is_answer_valid:bool
	for valid_answer in riddle_answers:
		if input_text.to_lower().contains(valid_answer):
			is_answer_valid = true
			break
	return is_answer_valid

func _on_submit_button_down():
	if evaluate_answer(text_box.text):
		print("answer is VALID")
		#give player gold/Dice/Item/Charm
		end_riddle(true)
	else:
		print("answer is INVALID")
		#start battle with sphynx
		end_riddle(false)
		

func end_riddle(is_correct):
	correct = is_correct
	riddle_results_body.text = game_manager.riddle_lib.results_text[correct].pick_random()
	riddle_reward_label.visible = correct
	
	if correct:
		#pick reward
		var reward_inventory:Array[Dictionary]
		var new_gold = game_manager.item_lib.player_shop_coin_data.duplicate(true)
		for i in game_manager.rng.randi_range(3,9):#how many rewards
			match game_manager.rng.randi_range(1,4):#what kind of reward
				1:#dice
					reward_inventory.append(game_manager.dice_lib.all_dice.values().pick_random())
				2:#items
					reward_inventory.append(game_manager.item_lib.all_items.values().pick_random())
				3:#charms
					reward_inventory.append(game_manager.item_lib.all_charms.values().pick_random())
				4:#gold
					new_gold["coin_amount"] += 300
					if !reward_inventory.has(new_gold):
						reward_inventory.append(new_gold)
		evaluate_reward(reward_inventory)
	
	#shows riddle results needs to be last VVV
	riddle_result.visible = true

func _on_riddle_result_button_button_down():#final result button
	if correct:
		$"../choice_creator".poi_manager()
		queue_free()
	else:
		riddle_reward_label.visible = false
		var next_dice_battle = game_manager.dice_battle_prefab.instantiate()
		$"../..".add_child(next_dice_battle)
		next_dice_battle.setup_dice_batle({"enemies":[game_manager.enemy_lib.sphynx_enemy_resource],"reward":80})
		queue_free()

func display_reward(inventory:Array[Dictionary]):
	#show player rewards
	for reward in inventory:
		var next_display_item = game_manager.picture_item_prefab.instantiate()
		riddle_reward_grid.add_child(next_display_item)
		next_display_item.setup_item(reward)
	
	
	#give player reward
	for reward in inventory:
		if reward["item_code"] != 5 && reward["item_code"] != 4:
			game_manager.player_resource.getset_inventory("add",reward)
		elif reward["item_code"] == 4:
			game_manager.add_charm(reward["item_name"])
		else:
			game_manager.player_resource.gold += reward["coin_amount"]
	
	

func evaluate_reward(rewards):
	print("evaluating rewards: ", rewards)
	display_reward(rewards)
	
