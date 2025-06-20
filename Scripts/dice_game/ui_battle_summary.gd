extends Node2D

var game_manager = GameManager

var summary_data:Dictionary = {
#	"enemies":int,
#	"reward":String|int,
#	"dice":Array[Dictionary]
}
var dice_reward_parent


func setup_summary(input_data:Dictionary):
	var ui_enemies = $HBoxContainer/right_side/ui_enemies
	var ui_reward = $HBoxContainer/right_side/ui_reward
	var ui_gold = $HBoxContainer/right_side/ui_gold
	var gold_label = $HBoxContainer/left_side/gold_Label3
	dice_reward_parent = $dice_reward/reward_dice
	
	summary_data = input_data
	
	ui_enemies.text = var_to_str(summary_data["enemies"])
	if typeof(summary_data["reward"]) == TYPE_INT:#is a gold Reward
		ui_reward.text = "gold"
		ui_gold.text = var_to_str(summary_data["reward"] + summary_data["battle_gold"])
		dice_reward_parent.get_parent().visible = false
	else:
		ui_reward.text = summary_data["reward"]
		gold_label.visible = false
		ui_gold.visible = false
		add_dice_to_reward_grid(summary_data["dice"])
		if summary_data["battle_gold"] >=1:
			gold_label.visible = true
			ui_gold.visible = true
			ui_gold.text = var_to_str(summary_data["battle_gold"])
			
			
			
func add_dice_to_reward_grid(input_data:Array[Dictionary]):
	for dice_data in input_data:
		#non-clickable item prefab goes here
		var next_dice = game_manager.picture_item_prefab.instantiate()
		dice_reward_parent.add_child(next_dice)
		next_dice.setup_item(dice_data)
	
	
	
	
	


func _on_button_button_down():
	get_parent().summary_complete()
