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
@export var game_level:int

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
	game_level = 0
	print("new health now ", health)
	
func battle_reset():
	shield = default_shield
	reflect = 0
#reset value
#var inventory:Array[Dictionary]
var inventory:Array[Dictionary] = [
	{
	"item_code":2,
	"item_name":"die_pack",
	"texture":"res://Sprites/shop/specialty_shops/dice_pack_item.png",
	"price":80,
	"long_name":"Dice Pack",
	"description":"Open the pack for 3 random dice"
	},
	{
	"item_code":2,
	"item_name":"hea_potion",
	"texture":"res://Sprites/shop/specialty_shops/health_potion_item.png",
	"price":20,
	"long_name":"Health Potion",
	"description":"Heal 25% Health"
	},
	{
	"item_code":2,
	"item_name":"ite_bomb",
	"texture":"res://Sprites/shop/specialty_shops/bomb_item.png",
	"price":50,
	"long_name":"Bomb",
	"description":"Deal 30 Damage to all enemies (Can only use in combat)"
	},
	{
	"item_code":0,
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"item_code":0,
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"item_code":0,
	"default":true,
	"item_name":"fir_dice"
	}
]

var dice_deck:Array[Dictionary] = [
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"fir_dice"
	},
	{
	"default":true,
	"item_name":"def_dice"
	},
	{
	"default":true,
	"item_name":"def_dice"
	},
	{
	"default":true,
	"item_name":"def_dice"
	},
	{
	"default":true,
	"item_name":"def_dice"
	},
	{
	"default":true,
	"item_name":"hel_dice"
	},
	{
	"default":true,
	"item_name":"hel_dice"
	},
	{
	"default":true,
	"item_name":"hel_dice"
	},
	{
	"default":true,
	"item_name":"hel_dice"
	}
]

func getset_dice_deck(choice:String,input_data):
	match choice:
		"get":
			#print("sending deck: ",dice_deck)
			return dice_deck.duplicate(true)
		"get_converted":
			var dice_lib = load("res://Resources/dice_library.tres")
			var send_array:Array[Dictionary]
			for die in dice_deck:
				
				if die.has("default"):
					#print("checking: ", die)
					send_array.append(dice_lib.get_dice_data(die["item_name"]))
				else:
					send_array.append(die)
			return send_array
		"set":
			dice_deck.clear()
			if typeof(input_data) == TYPE_ARRAY:
				for data in input_data:
					if typeof(data) == TYPE_DICTIONARY:
						dice_deck.append(data)
		"add":
			if typeof(input_data) == TYPE_ARRAY:
				for data in input_data:
					if typeof(data) == TYPE_DICTIONARY:
						dice_deck.append(data)
			elif typeof(input_data) == TYPE_DICTIONARY:
				dice_deck.append(input_data)
		_:
			print("no:Player_Resoure")
	

	
func getset_inventory(choice:String,input_data):
	match choice:
		"get":
			#print("sending deck: ",dice_deck)
			return inventory.duplicate(true)
		"set":
			inventory.clear()
			if typeof(input_data) == TYPE_ARRAY:
				for data in input_data:
					if typeof(data) == TYPE_DICTIONARY:
						inventory.append(data)
		_:
			print("no:Player_Resoure")
