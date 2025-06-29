extends TextureRect

var game_manager = GameManager

var current_dice_type:int#DiceType coded

#LLO 6/28 finish making required dice exclusive to dice type
func setup_dice_requirement(input_data):
	current_dice_type = input_data
	
	match current_dice_type:
		0:#ATTACK,#0
			texture = load("res://Sprites/Dice/attack dice template.png")
		1:#DEFEND,#1
			texture = load("res://Sprites/Dice/defend dice template.png")
		2:#REROLL,#2
			texture = load("res://Sprites/Dice/reroll dice template.png")
		3:#BLEED,#3
			texture = load("res://Sprites/Dice/bleed dice template.png")
		4:#HEAL,#4
			texture = load("res://Sprites/Dice/none heal face.png")
		5:#GOLD,#5
			texture = load("res://Sprites/Dice/none gold dice.png")
		6:#REFLECT,#6
			texture = load("res://Sprites/Dice/none reflect dice.png")
		7:#LIFESTEAL,#7
			texture = load("res://Sprites/Dice/none lifesteal dice.png")
		8:#POISON,#8
			texture = load("res://Sprites/Dice/none poison dice.png")
		9:#CURE,#9
			texture = load("res://Sprites/Dice/none cure dice.png")
		10:#DISARM,#10
			texture = load("res://Sprites/Dice/none disarm dice.png")
		11:#STUN,#11
			texture = load("res://Sprites/Dice/none stun dice.png")
		12:#ATKBUFF,#12
			texture = load("res://Sprites/Dice/none buff dice.png")
		13:#DEFBUFF,#13
			texture = load("res://Sprites/Dice/none buff dice.png")
		14:#ATKDEBUFF,#14
			texture = load("res://Sprites/Dice/none debuff dice.png")
		15:#DEFDEBUFF,#15
			texture = load("res://Sprites/Dice/none debuff dice.png")
		16:#FIRE,#16
			texture = load("res://Sprites/Dice/none fire dice.png")
		17:#ICE,#17
			texture = load("res://Sprites/Dice/none ice dice.png")
		18:#LIGHTNING,#18
			texture = load("res://Sprites/Dice/none lightning dice.png")
		19:#NONE#19
			texture = load("res://Sprites/Dice/blank dice template.png")
	pass
