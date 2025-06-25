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
@export var default_max_health:int
@export var default_health:int
@export var default_attack:int
@export var default_defend:int
@export var default_shield:int
@export var default_heal_power:int
@export var default_deck_size:int
@export var default_dice_bonus:float

@export var battle_wins:int
@export var game_level:int


#charm modifiers
var health_modifier:int
var shop_coupon:int#do last to get ready to finalize shop
var atk_shield:int
var shl_attack:int
var salvage_tool:int
var shield_up:int
var heal_up:int
var cornicopia_draw:int
var meditate:int
var battle_gold:int
var cure_heal:int
var piercing:int
var thorns:int
var toxic_orb:int
var mega_debuff:int
var vamp_thread:int
var iron_root:int
var fire_resist:int
var bleed_resist:int
var poison_resist:int
var lightning_resist:int
var ice_resist:int
var investment:int

# skill upgrades
var action_slot_upgrade:bool
var sweeping_edge_upgrade:bool
var lay_on_hands_upgrade:bool
var swagger_upgrade:bool
var second_skin_upgrade:bool
var emergency_cache_upgrade:bool
var charm_sync_upgrade:bool

func reset_values():
	print("player resource resetting values")
	max_health = default_max_health
	health = default_health
	attack = default_attack
	defend = default_defend
	shield = default_shield
	reflect = 0
	heal_power = default_heal_power
	gold = 300#0
	game_level = 0
	hand_size = 5
	action_size = 3
	reset_charms()
	print("new health now ", health)
	
#hp up stuff
func hpup_health(hp_up_amount:int):
	health_modifier = hp_up_amount
	max_health += (20*health_modifier)
	health += (20*health_modifier)
	pass
	
func battle_reset():
	shield = default_shield
	reflect = 0
	
func reset_charms():
	health_modifier=0
	shop_coupon=0
	atk_shield=0
	shl_attack=0
	salvage_tool=0
	shield_up=0
	heal_up=0
	cornicopia_draw=0
	meditate=0
	battle_gold=0
	cure_heal=0
	piercing=0
	thorns=0
	toxic_orb=0
	mega_debuff=0
	vamp_thread=0
	iron_root=0
	fire_resist=0
	bleed_resist=0
	poison_resist=0
	lightning_resist=0
	ice_resist=0
	investment=0
	
func reset_skills():
	action_slot_upgrade= false
	sweeping_edge_upgrade= false
	lay_on_hands_upgrade= false
	swagger_upgrade= false
	second_skin_upgrade= false
	emergency_cache_upgrade= false
	charm_sync_upgrade= false
#reset value
#var inventory:Array[Dictionary]
var inventory:Array[Dictionary] = [
	{"item_code":0,
	"item_name":"fir_dice",
	"texture":"res://Sprites/Dice/one fire dice.png",
	"none_texture":"res://Sprites/Dice/none fire dice.png",
	"two_texture":"res://Sprites/Dice/2 fire dice.png",
	"three_texture":"res://Sprites/Dice/3 fire dice.png",
	"four_texture":"res://Sprites/Dice/4 fire dice.png",
	"mini_texture":"res://sprites/mini fire dice.png",
	"price":30,
	"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.FIRE,
	"effect":Status_Library.StatusCondition.BURN,
	"element":Dice.DamageElement.FIRE,
	"long_name":"Fire Dice",
	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"}
	]
#var inventory:Array[Dictionary] = [{
#	"item_code":2,
#	"item_name":"die_pack",
#	"texture":"res://Sprites/shop/specialty_shops/dice_pack_item.png",
#	"price":80,
#	"use_type":0,
#	"long_name":"Dice Pack",
#	"description":"Open the pack for 3 random dice"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_mims",
#	"texture":"res://Sprites/shop/items/mimic shard.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"mimic shard",
#	"description":"copy attack dice of any enemy and roll it for yourself"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_fatf",
#	"texture":"res://Sprites/shop/items/fate fragment.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"fate fragment",
#	"description":"discard one dice and draw 2"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_forc",
#	"texture":"res://Sprites/shop/items/forge core.png",
#	"price":0,
#	"use_type":0,
#	"long_name":"forge core",
#	"description":"upgrade one dice by one stage"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_actu",
#	"texture":"res://Sprites/shop/items/Action up.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"action up",
#	"description":"gives you one extra action slot for 3 turns"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_actu",
#	"texture":"res://Sprites/shop/items/Action up.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"action up",
#	"description":"gives you one extra action slot for 3 turns"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_aegc",
#	"texture":"res://Sprites/shop/items/aegis coin.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"aegis coin",
#	"description":"nullifies all damage for one turn"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_cocc",
#	"texture":"res://Sprites/shop/items/coconut candy.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"coconut candy",
#	"description":"doubles values of submit dice"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_cocc",
#	"texture":"res://Sprites/shop/items/coconut candy.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"coconut candy",
#	"description":"doubles values of submit dice"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_cocc",
#	"texture":"res://Sprites/shop/items/coconut candy.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"coconut candy",
#	"description":"doubles values of submit dice"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_cocc",
#	"texture":"res://Sprites/shop/items/coconut candy.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"coconut candy",
#	"description":"doubles values of submit dice"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_dicf",
#	"texture":"res://Sprites/shop/items/dictated fate.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"dictated fate dice",
#	"description":"set one dice to its highest value"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_rage",
#	"texture":"res://Sprites/shop/items/damage potion.png",
#	"price":50,
#	"use_type":2,
#	"long_name":"rage potion",
#	"description":"Give player attack stat boost for 3 battles"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_disd",
#	"texture":"res://Sprites/shop/items/disarm dust.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"disarm dust",
#	"description":"disarms targeted enemy for 3 turns"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_help",
#	"texture":"res://Sprites/shop/items/health potion.png",
#	"price":0,
#	"use_type":2,
#	"long_name":"heal power potion",
#	"description":"this potion buffs your heal power for 3 battles"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_onet",
#	"texture":"res://Sprites/shop/items/one arm tie.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"one-arm tie",
#	"description":"makes targeted enemy take one less action per turn"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_rewi",
#	"texture":"res://Sprites/shop/items/rewind.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"rewind",
#	"description":"reroll all dice in hand"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_rewi",
#	"texture":"res://Sprites/shop/items/rewind.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"rewind",
#	"description":"reroll all dice in hand"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_rewi",
#	"texture":"res://Sprites/shop/items/rewind.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"rewind",
#	"description":"reroll all dice in hand"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_ship",
#	"texture":"res://Sprites/shop/items/shield potion.png",
#	"price":0,
#	"use_type":2,
#	"long_name":"shield power potion",
#	"description":"this potion buffs your shiled power for 3 turns"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_smok",
#	"texture":"res://Sprites/shop/items/smokescreen.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"smokescreen",
#	"description":"adds possibility for enemy to miss attacks"
#	},
#		{
#	"item_code":2,
#	"item_name":"ite_smok",
#	"texture":"res://Sprites/shop/items/smokescreen.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"smokescreen",
#	"description":"adds possibility for enemy to miss attacks"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_smok",
#	"texture":"res://Sprites/shop/items/smokescreen.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"smokescreen",
#	"description":"adds possibility for enemy to miss attacks"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_smok",
#	"texture":"res://Sprites/shop/items/smokescreen.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"smokescreen",
#	"description":"adds possibility for enemy to miss attacks"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_smok",
#	"texture":"res://Sprites/shop/items/smokescreen.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"smokescreen",
#	"description":"adds possibility for enemy to miss attacks"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_wead",
#	"texture":"res://Sprites/shop/items/weakness dust.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"weakness dust",
#	"description":"makes targeted enemy's attacks weaker"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_wead",
#	"texture":"res://Sprites/shop/items/weakness dust.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"weakness dust",
#	"description":"makes targeted enemy's attacks weaker"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_trad",
#	"texture":"res://Sprites/shop/items/trap disarmer.png",
#	"price":0,
#	"use_type":1,
#	"long_name":"trap disarmer",
#	"description":"disarms traps completing the key and rendering it useless"
#	},
#	{
#	"item_code":2,
#	"item_name":"ite_cure",
#	"texture":"res://Sprites/shop/items/cure potion.png",
#	"price":20,
#	"use_type":1,
#	"long_name":"cure potion",
#	"description":" this potion cures all negative status effects when used"
#	},
#	{
#	"item_code":0,
#	"item_name":"fir_dice",
#	"texture":"res://Sprites/Dice/one fire dice.png",
#	"none_texture":"res://Sprites/Dice/none fire dice.png",
#	"two_texture":"res://Sprites/Dice/2 fire dice.png",
#	"three_texture":"res://Sprites/Dice/3 fire dice.png",
#	"four_texture":"res://Sprites/Dice/4 fire dice.png",
#	"mini_texture":"res://sprites/mini fire dice.png",
#	"price":30,
#	"upgrade_level":6,
#	"animation_target":"target",
#	"type":Dice.DiceType.FIRE,
#	"effect":Status_Library.StatusCondition.BURN,
#	"element":Dice.DamageElement.FIRE,
#	"long_name":"Fire Dice",
#	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"
#	},
#	{
#	"item_code":0,
#	"item_name":"fir_dice",
#	"texture":"res://Sprites/Dice/one fire dice.png",
#	"none_texture":"res://Sprites/Dice/none fire dice.png",
#	"two_texture":"res://Sprites/Dice/2 fire dice.png",
#	"three_texture":"res://Sprites/Dice/3 fire dice.png",
#	"four_texture":"res://Sprites/Dice/4 fire dice.png",
#	"mini_texture":"res://sprites/mini fire dice.png",
#	"price":30,
#	"upgrade_level":6,
#	"animation_target":"target",
#	"type":Dice.DiceType.FIRE,
#	"effect":Status_Library.StatusCondition.BURN,
#	"element":Dice.DamageElement.FIRE,
#	"long_name":"Fire Dice",
#	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"
#	},
#	{
#	"item_code":0,
#	"item_name":"fir_dice",
#	"texture":"res://Sprites/Dice/one fire dice.png",
#	"none_texture":"res://Sprites/Dice/none fire dice.png",
#	"two_texture":"res://Sprites/Dice/2 fire dice.png",
#	"three_texture":"res://Sprites/Dice/3 fire dice.png",
#	"four_texture":"res://Sprites/Dice/4 fire dice.png",
#	"mini_texture":"res://sprites/mini fire dice.png",
#	"price":30,
#	"upgrade_level":6,
#	"animation_target":"target",
#	"type":Dice.DiceType.FIRE,
#	"effect":Status_Library.StatusCondition.BURN,
#	"element":Dice.DamageElement.FIRE,
#	"long_name":"Fire Dice",
#	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"
#	}]

var dice_deck:Array[Dictionary] = [
	{
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
	},
	{
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
	},
	{
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
	},
	{
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
	},
	{
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
	},
	{
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
	},
	{
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
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
	"upgrade_level":6,
	"animation_target":"target",
	"type":Dice.DiceType.POISON,
	"effect":Status_Library.StatusCondition.POISON,
	"element":Dice.DamageElement.POISON,
	"is_temp":false,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	},
	{
	"item_code":0,
	"item_name":"cur_dice",
	"texture":"res://Sprites/Dice/one cure dice.png",
	"none_texture":"res://Sprites/Dice/none cure dice.png",
	"two_texture":"res://Sprites/Dice/2 cure dice.png",
	"three_texture":"res://Sprites/Dice/3 cure dice.png",
	"four_texture":"res://Sprites/Dice/4 cure dice.png",
	"price":15,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.CURE,
	"effect":Status_Library.StatusCondition.CURE,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Cure Dice",
	"description":"cures you of all negative status effects"
	},
	{
	"item_code":0,
	"item_name":"cur_dice",
	"texture":"res://Sprites/Dice/one cure dice.png",
	"none_texture":"res://Sprites/Dice/none cure dice.png",
	"two_texture":"res://Sprites/Dice/2 cure dice.png",
	"three_texture":"res://Sprites/Dice/3 cure dice.png",
	"four_texture":"res://Sprites/Dice/4 cure dice.png",
	"price":15,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.CURE,
	"effect":Status_Library.StatusCondition.CURE,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Cure Dice",
	"description":"cures you of all negative status effects"
	},
	{
	"item_code":0,
	"item_name":"cur_dice",
	"texture":"res://Sprites/Dice/one cure dice.png",
	"none_texture":"res://Sprites/Dice/none cure dice.png",
	"two_texture":"res://Sprites/Dice/2 cure dice.png",
	"three_texture":"res://Sprites/Dice/3 cure dice.png",
	"four_texture":"res://Sprites/Dice/4 cure dice.png",
	"price":15,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.CURE,
	"effect":Status_Library.StatusCondition.CURE,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Cure Dice",
	"description":"cures you of all negative status effects"
	},
	{
	"item_code":0,
	"item_name":"cur_dice",
	"texture":"res://Sprites/Dice/one cure dice.png",
	"none_texture":"res://Sprites/Dice/none cure dice.png",
	"two_texture":"res://Sprites/Dice/2 cure dice.png",
	"three_texture":"res://Sprites/Dice/3 cure dice.png",
	"four_texture":"res://Sprites/Dice/4 cure dice.png",
	"price":15,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.CURE,
	"effect":Status_Library.StatusCondition.CURE,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Cure Dice",
	"description":"cures you of all negative status effects"
	},
	{
	"item_code":0,
	"item_name":"cur_dice",
	"texture":"res://Sprites/Dice/one cure dice.png",
	"none_texture":"res://Sprites/Dice/none cure dice.png",
	"two_texture":"res://Sprites/Dice/2 cure dice.png",
	"three_texture":"res://Sprites/Dice/3 cure dice.png",
	"four_texture":"res://Sprites/Dice/4 cure dice.png",
	"price":15,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.CURE,
	"effect":Status_Library.StatusCondition.CURE,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Cure Dice",
	"description":"cures you of all negative status effects"
	},
	{
	"item_code":0,
	"item_name":"def_dice",
	"texture":"res://Sprites/Dice/defend dice.png",
	"none_texture":"res://Sprites/Dice/defend dice template.png",
	"two_texture":"res://Sprites/Dice/defend dice 2.png",
	"three_texture":"res://Sprites/Dice/defend dice 3.png",
	"four_texture":"res://Sprites/Dice/defend dice 4.png",
	"price":20,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.DEFEND,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Defence Dice",
	"description":"Basic Defence Dice"
	},
	{
	"item_code":0,
	"item_name":"def_dice",
	"texture":"res://Sprites/Dice/defend dice.png",
	"none_texture":"res://Sprites/Dice/defend dice template.png",
	"two_texture":"res://Sprites/Dice/defend dice 2.png",
	"three_texture":"res://Sprites/Dice/defend dice 3.png",
	"four_texture":"res://Sprites/Dice/defend dice 4.png",
	"price":20,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.DEFEND,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Defence Dice",
	"description":"Basic Defence Dice"
	},
	{
	"item_code":0,
	"item_name":"def_dice",
	"texture":"res://Sprites/Dice/defend dice.png",
	"none_texture":"res://Sprites/Dice/defend dice template.png",
	"two_texture":"res://Sprites/Dice/defend dice 2.png",
	"three_texture":"res://Sprites/Dice/defend dice 3.png",
	"four_texture":"res://Sprites/Dice/defend dice 4.png",
	"price":20,
	"upgrade_level":6,
	"animation_target":"self",
	"type":Dice.DiceType.DEFEND,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Defence Dice",
	"description":"Basic Defence Dice"
	}
]

var charm_inventory:Array[Dictionary] = [
#	{
#	"item_code":4,
#	"item_name":"cha_hpup",
#	"texture":"res://Sprites/charms/HP up.png",
#	"long_name":"+max hp",
#	"description":"increases current max hp"
#	},
#	{
#	"item_code":4,
#	"item_name":"cha_coupon",
#	"texture":"res://Sprites/charms/shop_coupon.png",
#	"long_name":"shop coupon",
#	"description":"provides a 5% off all shop items up to 50%"
#	},
#	{
#	"item_code":4,
#	"item_name":"cha_atks",
#	"texture":"res://Sprites/charms/attacks_shield.png",
#	"long_name":"Offensive Defence",
#	"description":"all attack will also provide one shield stack"
#	}
]

var skills_inventory:Array[Dictionary] = [
	
]


func getset_charm_inventory(choice:String,input_data):
	match choice:
		"get":
			return charm_inventory.duplicate(true)
		"check":
			if charm_inventory.any(func(charm): return charm["item_name"] == "cha_hpup"):
				return  charm_inventory.count({"item_code":4,"item_name":"cha_hpup","texture":"res://Sprites/charms/HP up.png","long_name":"+max hp","description":"increases current max hp"})
			else:
				return false
		_:
			print("no:Player_Resoure")

func getset_skill_inventory(choice:String, input_data):
	match choice:
		"get":
			return skills_inventory.duplicate(true)
		_:
			print("no:Player_Resoure")


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
	
	
	
	
