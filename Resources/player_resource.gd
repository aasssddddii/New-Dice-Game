extends Resource
class_name Player_Resource



@export var max_health:int
@export var health:int
@export var attack:int
@export var magic_power:int
@export var defend:int
@export var shield:int
@export var heal_power:int
@export var gold:int

#statuses
@export var reflect:int

#@export var boss_keys:int

#@export var next_wish:GameManager.WishType = GameManager.WishType.NONE

@export var default_health:int
@export var default_attack:int
@export var default_defend:int
@export var default_shield:int
@export var default_heal_power:int

@export var battle_wins:int

func reset_values():
	print("player resource ressetting values")
	max_health = default_health
	health = default_health
	attack = default_attack
	defend = default_defend
	shield = default_shield
	reflect = 0
	heal_power = default_heal_power
	gold = 0
	print("new health now ", health)
	
func battle_reset():
	shield = default_shield
	reflect = 0



var dice_deck:Array[Dictionary] = [
	{
	"default":true,
	"dice_name":"bld_dice"
	},
	{
	"default":true,
	"dice_name":"bld_dice"
	},
	{
	"default":true,
	"dice_name":"bld_dice"
	},
	{
	"default":true,
	"dice_name":"bld_dice"
	},
	{
	"default":true,
	"dice_name":"lig_dice"
	},
	{
	"default":true,
	"dice_name":"lig_dice"
	},
	{
	"default":true,
	"dice_name":"lig_dice"
	},
	{
	"default":true,
	"dice_name":"lig_dice"
	},
	{
	"default":true,
	"dice_name":"fir_dice"
	},
	{
	"default":true,
	"dice_name":"fir_dice"
	},
	{
	"default":true,
	"dice_name":"fir_dice"
	},
	{
	"default":true,
	"dice_name":"fir_dice"
	},
	{
	"default":true,
	"dice_name":"ice_dice"
	},
	{
	"default":true,
	"dice_name":"ice_dice"
	},
	{
	"default":true,
	"dice_name":"ice_dice"
	},
	{
	"default":true,
	"dice_name":"ice_dice"
	}
]

func getset_dice_deck(choice:String,input_data):
	match choice:
		"get":
			return dice_deck
		"set":
			if typeof(input_data) == TYPE_ARRAY:
				for data in input_data:
					if typeof(data) == TYPE_DICTIONARY:
						dice_deck.append(data)
		_:
			print("no:Player_Resoure")
	
