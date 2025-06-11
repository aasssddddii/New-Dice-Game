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
@export var deck_size:int
@export var current_deck_amount:int
@export var all_dice_bonus:float
@export var hand_size:int
@export var action_size:int


#statuses
@export var reflect:int

#@export var boss_keys:int

#@export var next_wish:GameManager.WishType = GameManager.WishType.NONE

@export var default_health:int
@export var default_attack:int
@export var default_defend:int
@export var default_shield:int
@export var default_heal_power:int
@export var default_deck_size:int
@export var default_dice_bonus:float

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
	hand_size = 5
	action_size = 3
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
	"use_type":0,
	"long_name":"Dice Pack",
	"description":"Open the pack for 3 random dice"
	},
	{
	"item_code":2,
	"item_name":"ite_mims",
	"texture":"res://Sprites/shop/items/mimic shard.png",
	"price":0,
	"use_type":1,
	"long_name":"mimic shard",
	"description":"copy attack dice of any enemy and roll it for yourself"
	},
	{
	"item_code":2,
	"item_name":"ite_fatf",
	"texture":"res://Sprites/shop/items/fate fragment.png",
	"price":0,
	"use_type":1,
	"long_name":"fate fragment",
	"description":"discard one dice and draw 2"
	},
	{
	"item_code":2,
	"item_name":"ite_forc",
	"texture":"res://Sprites/shop/items/forge core.png",
	"price":0,
	"use_type":0,
	"long_name":"forge core",
	"description":"upgrade one dice by one stage"
	},
	{
	"item_code":2,
	"item_name":"ite_actu",
	"texture":"res://Sprites/shop/items/Action up.png",
	"price":0,
	"use_type":1,
	"long_name":"action up",
	"description":"gives you one extra action slot for 3 turns"
	},
	{
	"item_code":2,
	"item_name":"ite_actu",
	"texture":"res://Sprites/shop/items/Action up.png",
	"price":0,
	"use_type":1,
	"long_name":"action up",
	"description":"gives you one extra action slot for 3 turns"
	},
	{
	"item_code":2,
	"item_name":"ite_aegc",
	"texture":"res://Sprites/shop/items/aegis coin.png",
	"price":0,
	"use_type":1,
	"long_name":"aegis coin",
	"description":"nullifies all damage for one turn"
	},
	{
	"item_code":0,
	"item_name":"fir_dice",
	"texture":"res://Sprites/Dice/one fire dice.png",
	"none_texture":"res://Sprites/Dice/none fire dice.png",
	"two_texture":"res://Sprites/Dice/2 fire dice.png",
	"three_texture":"res://Sprites/Dice/3 fire dice.png",
	"four_texture":"res://Sprites/Dice/4 fire dice.png",
	"mini_texture":"res://sprites/mini fire dice.png",
	"price":30,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.FIRE,
	"effect":Status_Library.StatusCondition.BURN,
	"element":Dice.DamageElement.FIRE,
	"long_name":"Fire Dice",
	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"fir_dice",
	"texture":"res://Sprites/Dice/one fire dice.png",
	"none_texture":"res://Sprites/Dice/none fire dice.png",
	"two_texture":"res://Sprites/Dice/2 fire dice.png",
	"three_texture":"res://Sprites/Dice/3 fire dice.png",
	"four_texture":"res://Sprites/Dice/4 fire dice.png",
	"mini_texture":"res://sprites/mini fire dice.png",
	"price":30,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.FIRE,
	"effect":Status_Library.StatusCondition.BURN,
	"element":Dice.DamageElement.FIRE,
	"long_name":"Fire Dice",
	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"fir_dice",
	"texture":"res://Sprites/Dice/one fire dice.png",
	"none_texture":"res://Sprites/Dice/none fire dice.png",
	"two_texture":"res://Sprites/Dice/2 fire dice.png",
	"three_texture":"res://Sprites/Dice/3 fire dice.png",
	"four_texture":"res://Sprites/Dice/4 fire dice.png",
	"mini_texture":"res://sprites/mini fire dice.png",
	"price":30,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.FIRE,
	"effect":Status_Library.StatusCondition.BURN,
	"element":Dice.DamageElement.FIRE,
	"long_name":"Fire Dice",
	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"
	}
]

var dice_deck:Array[Dictionary] = [
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"ice_dice",
	"texture":"res://Sprites/Dice/one ice dice.png",
	"none_texture":"res://Sprites/Dice/none ice dice.png",
	"two_texture":"res://Sprites/Dice/2 ice dice.png",
	"three_texture":"res://Sprites/Dice/3 ice dice.png",
	"four_texture":"res://Sprites/Dice/4 ice dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ICE,
	"effect":false,
	"element":Dice.DamageElement.ICE,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"poi_dice",
	"texture":"res://Sprites/Dice/one poison dice.png",
	"none_texture":"res://Sprites/Dice/none poison dice.png",
	"two_texture":"res://Sprites/Dice/2 poison dice.png",
	"three_texture":"res://Sprites/Dice/3 poison dice.png",
	"four_texture":"res://Sprites/Dice/4 poison dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	}
]

var charm_inventory:Array[Dictionary] = [
	{
	"item_code":4,
	"item_name":"cha_hpup",
	"texture":"res://Sprites/charms/HP up.png",
	"long_name":"+max hp",
	"description":"increases current max hp"
	},
	{
	"item_code":4,
	"item_name":"cha_coupon",
	"texture":"res://Sprites/charms/shop_coupon.png",
	"long_name":"shop coupon",
	"description":"provides a 5% off all shop items up to 50%"
	},
	{
	"item_code":4,
	"item_name":"cha_atks",
	"texture":"res://Sprites/charms/attacks_shield.png",
	"long_name":"Offensive Defence",
	"description":"all attack will also provide one shield stack"
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
		"get_battle":
			var send_data:Array[Dictionary]
			for item in inventory:
				if item["item_code"] == 2:
					if item["use_type"] > 0:
						send_data.append(item)
			return send_data
		"get_map":
			var send_data:Array[Dictionary]
			for item in inventory:
				if item["item_code"] == 2:
					if item["use_type"] == 0:
						send_data.append(item)
			return send_data
		"get_dice":
			var dice_lib = load("res://Resources/dice_library.tres")
			var send_data:Array[Dictionary]
			for item in inventory:
				if item["item_code"] == 0:
					send_data.append(item)
			return send_data
		"get_item":
			var send_data:Array[Dictionary]
			for item in inventory:
				if item["item_code"] == 2:
					send_data.append(item)
			return send_data
		"set":
			inventory.clear()
			if typeof(input_data) == TYPE_ARRAY:
				for data in input_data:
					if typeof(data) == TYPE_DICTIONARY:
						inventory.append(data)
		"add":
			if typeof(input_data) == TYPE_ARRAY:
				for data in input_data:
					if typeof(data) == TYPE_DICTIONARY:
						inventory.append(data)
			elif typeof(input_data) == TYPE_DICTIONARY:
				inventory.append(input_data)
		_:
			print("no:Player_Resoure")
			
func manage_health(choice:String,amount:int):
	match choice:
		"add":
			health += amount
			if health > max_health:
				health = max_health
		"add_max":
			pass
	
	
	
	
