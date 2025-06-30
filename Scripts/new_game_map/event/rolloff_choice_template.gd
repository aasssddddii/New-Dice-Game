extends HBoxContainer

var game_manager = GameManager

@onready var choice_label = $Label

var choice_data:Dictionary

var confirm_button
var cancel_button

var dice_in_choice:Array[Dice]

# choice data template{
#		"text":"",
#		"required_dice":[],
#		"required_result":1,
#		"success_text":"",
#		"success_result": Event_Results,
#		"fail_text":"",
#		"fail_result":Event_Results}}

func setup_choice(input_data):
	choice_data = input_data
	
	confirm_button = $confirm_button
	cancel_button = $cancel_button
	
	confirm_button.visible = false
	cancel_button.visible = false
	
	choice_label.text = choice_data["text"] + " | " + var_to_str(choice_data["required_result"])
	for die_type in choice_data["required_dice"]:
		var next_required_dice = game_manager.rolloff_required_dice_prefab.instantiate()
		add_child(next_required_dice)
		next_required_dice.setup_dice_requirement(die_type)
		next_required_dice.dice_slot_filled.connect(filled_checker)
		move_child(next_required_dice,1)
	pass


func filled_checker():
	var any_dice_filled:bool
	var all_spot_filled:bool = true
	for child in get_children():
		if child is RequiredDice:
			if child.is_correct_filled_dice:
				any_dice_filled = true
				if !dice_in_choice.has(child.dice_in_slot):
					dice_in_choice.append(child.dice_in_slot)
				print("dice in choice now: ", dice_in_choice)
			else:
				all_spot_filled = false
				pass
	print("any dice filled: ", any_dice_filled, " all dice filled: ", all_spot_filled)
	cancel_button.visible = any_dice_filled
	confirm_button.visible = all_spot_filled

	
func _on_confirm_button_button_down():
	var filtered_array = dice_in_choice.filter(func(die): return die != null)
	#roll dice
	for die in filtered_array:
		die.roll()
	#evaluate dice
	var pip_count:int
	for die in filtered_array:
		pip_count += die.up_face
		
	var rolloff_event = $"../.."
	if pip_count >= choice_data["required_result"]:
		print("EVENT SUCCESS")
		await get_tree().create_timer(.5).timeout
		rolloff_event.setup_summary(choice_data["success_text"],choice_data["success_result"],choice_data["success_enemies"])
	else:
		print("EVENT FAIL")
		await get_tree().create_timer(.5).timeout
		rolloff_event.setup_summary(choice_data["fail_text"],choice_data["fail_result"],choice_data["fail_enemies"])
	#show summary screen


func _on_cancel_button_button_down():
	dice_in_choice.clear()
	for child in get_children():
		if child is RequiredDice:
			child.reset_dice_requirement()

