extends HBoxContainer

var game_manager = GameManager

@onready var choice_label = $Label

var choice_data:Dictionary

# choice data template{
#		"text":"",
#		"required_dice":[],
#		"success_result": Event_Results,
#		"fail_result":Event_Results}}

func setup_choice(input_data):
	choice_data = input_data
	
	choice_label.text = choice_data["text"]
	for die_type in choice_data["required_dice"]:
		var next_required_dice = game_manager.rolloff_required_dice_prefab.instantiate()
		add_child(next_required_dice)
		next_required_dice.setup_dice_requirement(die_type)
	pass
