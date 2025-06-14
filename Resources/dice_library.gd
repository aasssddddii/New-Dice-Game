extends Resource
class_name Dice_Library


const die_offset = Vector2(-28,-28)

var dice_prefab = preload("res://Prefabs/dice.tscn")

var upgrade_tier:Dictionary = {
	0:[0,0,0,1,1,1],
	1:[0,0,0,1,1,2],
	2:[0,0,1,1,1,2],
	3:[0,0,1,1,2,2],
	4:[0,0,1,1,2,3],
	5:[0,1,1,2,2,3],
	6:[0,1,2,2,3,3],
	7:[0,1,2,2,3,4],
	8:[1,2,2,3,3,4]
}
#upgrade faces
#1. [0,0,0,1,1,1]
#2. [0,0,0,1,1,2]
#3. [0,0,1,1,1,2]
#4. [0,0,1,1,2,2]
#5. [0,0,1,1,2,3]
#6. [0,1,1,2,2,3]
#7. [0,1,2,2,3,3]
#8. [0,1,2,2,3,4]
#9. [1,2,2,3,3,4]


var attack_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"atk_dice",
	"texture":"res://Sprites/Dice/one attack face.png",
	"none_texture":"res://Sprites/Dice/attack dice template.png",
	"two_texture":"res://Sprites/Dice/two attack face.png",
	"three_texture":"res://Sprites/Dice/three attack face.png",
	"four_texture":"res://Sprites/Dice/four attack face.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ATTACK,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Attack Dice",
	"description":"Basic attack dice"
	}
var defend_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"def_dice",
	"texture":"res://Sprites/Dice/defend dice.png",
	"none_texture":"res://Sprites/Dice/defend dice template.png",
	"two_texture":"res://Sprites/Dice/defend dice 2.png",
	"three_texture":"res://Sprites/Dice/defend dice 3.png",
	"four_texture":"res://Sprites/Dice/defend dice 4.png",
	"price":20,
	"upgrade_level":0,
	"animation_target":"self",
	"type":Dice.DiceType.DEFEND,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Defence Dice",
	"description":"Basic Defence Dice"
	}
var reroll_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"rrl_dice",
	"texture":"res://Sprites/Dice/reroll dice.png",
	"none_texture":"res://Sprites/Dice/reroll dice template.png",
	"two_texture":"res://Sprites/Dice/2 reroll dice.png",
	"three_texture":"res://Sprites/Dice/3 reroll dice.png",
	"four_texture":"res://Sprites/Dice/4 reroll dice.png",
	"price":35,
	"upgrade_level":0,
	"animation_target":"discard",
	"type":Dice.DiceType.REROLL,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Reroll Dice",
	"description":"reroll dice, drop on top of another dice to reroll both"
	}
var bleed_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"bld_dice",
	"texture":"res://Sprites/Dice/bleed dice.png",
	"none_texture":"res://Sprites/Dice/bleed dice template.png",
	"two_texture":"res://Sprites/Dice/bleed dice 2.png",
	"three_texture":"res://Sprites/Dice/bleed dice 3.png",
	"four_texture":"res://Sprites/Dice/bleed dice 4.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.BLEED,
	"effect":Status_Library.StatusCondition.BLEED,
	"element":Dice.DamageElement.BLEED,
	"is_temp":false,
	"long_name":"Bleed Dice",
	"description":"bleed dice, inflicts bleed damage for 3 turns"
	}
var heal_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"hel_dice",
	"texture":"res://Sprites/Dice/one heal face.png",
	"none_texture":"res://Sprites/Dice/heal dice template.png",
	"two_texture":"res://Sprites/Dice/2 heal face.png",
	"three_texture":"res://Sprites/Dice/3 heal face.png",
	"four_texture":"res://Sprites/Dice/4 heal face.png",
	"price":10,
	"upgrade_level":0,
	"animation_target":"self",
	"type":Dice.DiceType.HEAL,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Heal Dice",
	"description":"Basic heal dice"
	}
var gold_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"gld_dice",
	"texture":"res://Sprites/Dice/one gold dice.png",
	"none_texture":"res://Sprites/Dice/none gold dice.png",
	"two_texture":"res://Sprites/Dice/2 gold dice.png",
	"three_texture":"res://Sprites/Dice/3 gold dice.png",
	"four_texture":"res://Sprites/Dice/4 gold dice.png",
	"price":5,
	"shop_quantity":0,
	"inventory_quantity":0,
	"upgrade_level":0,
	"animation_target":"discard",
	"type":Dice.DiceType.GOLD,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Gold Dice",
	"description":"Gold dice, provides 1 gold upon use"
	}
var reflect_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"ref_dice",
	"texture":"res://Sprites/Dice/one reflect dice.png",
	"none_texture":"res://Sprites/Dice/none reflect dice.png",
	"two_texture":"res://Sprites/Dice/2 reflect dice.png",
	"three_texture":"res://Sprites/Dice/3 reflect dice.png",
	"four_texture":"res://Sprites/Dice/4 reflect dice.png",
	"price":10,
	"upgrade_level":0,
	"animation_target":"self",
	"type":Dice.DiceType.REFLECT,
	"effect":Status_Library.StatusCondition.REFLECT,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Reflect Dice",
	"description":"reflect dice, reflects damage back to enemys. you still take damage"
	}
var lifesteal_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"lfs_dice",
	"texture":"res://Sprites/Dice/one lifesteal dice.png",
	"none_texture":"res://Sprites/Dice/none lifesteal dice.png",
	"two_texture":"res://Sprites/Dice/2 lifesteal dice.png",
	"three_texture":"res://Sprites/Dice/3 lifesteal dice.png",
	"four_texture":"res://Sprites/Dice/4 lifesteal dice.png",
	"price":40,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.LIFESTEAL,
	"is_temp":false,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"long_name":"lifesteal Dice",
	"description":"lifesteal dice, Heals you for the damage you deal"
	}
var poison_dice_shop_data:Dictionary = {
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
	"is_temp":false,
	"long_name":"Poison Dice",
	"description":"deals half attack as poison damage, and inflicts poison damage for 3 turns"
	}
var cure_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"cur_dice",
	"texture":"res://Sprites/Dice/one cure dice.png",
	"none_texture":"res://Sprites/Dice/none cure dice.png",
	"two_texture":"res://Sprites/Dice/2 cure dice.png",
	"three_texture":"res://Sprites/Dice/3 cure dice.png",
	"four_texture":"res://Sprites/Dice/4 cure dice.png",
	"price":15,
	"upgrade_level":0,
	"animation_target":"self",
	"type":Dice.DiceType.CURE,
	"effect":Status_Library.StatusCondition.CURE,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Cure Dice",
	"description":"cures you of all negative status effects"
	}
var stun_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"stn_dice",
	"texture":"res://Sprites/Dice/one stun dice.png",
	"none_texture":"res://Sprites/Dice/none stun dice.png",
	"two_texture":"res://Sprites/Dice/2 stun dice.png",
	"three_texture":"res://Sprites/Dice/3 stun dice.png",
	"four_texture":"res://Sprites/Dice/4 stun dice.png",
	"price":30,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.STUN,
	"effect":Status_Library.StatusCondition.STUN,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Stun Dice",
	"description":"Stuns an enemy for 2 turn"
	}
var disarm_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"dis_dice",
	"texture":"res://Sprites/Dice/one disarm dice.png",
	"none_texture":"res://Sprites/Dice/none disarm dice.png",
	"two_texture":"res://Sprites/Dice/2 disarm dice.png",
	"three_texture":"res://Sprites/Dice/3 disarm dice.png",
	"four_texture":"res://Sprites/Dice/4 disarm dice.png",
	"price":20,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.DISARM,
	"effect":Status_Library.StatusCondition.DISARM,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Disarm Dice",
	"description":"Disables the enemy from attacking for 3 turns"
	}
var buff_attack_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"bfa_dice",
	"texture":"res://Sprites/Dice/one buff attack dice.png",
	"none_texture":"res://Sprites/Dice/none buff dice.png",
	"two_texture":"res://Sprites/Dice/2 buff attack dice.png",
	"three_texture":"res://Sprites/Dice/3 buff attack dice.png",
	"four_texture":"res://Sprites/Dice/4 buff attack dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"self",
	"type":Dice.DiceType.ATKBUFF,
	"effect":Status_Library.StatusCondition.ATKBUFF,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Buff Attack Dice",
	"description":"Buff your attack x1.5 for 3 turns"
	}
var buff_defence_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"bfd_dice",
	"texture":"res://Sprites/Dice/one buff defence dice.png",
	"none_texture":"res://Sprites/Dice/none buff dice.png",
	"two_texture":"res://Sprites/Dice/2 buff defence dice.png",
	"three_texture":"res://Sprites/Dice/3 buff defence dice.png",
	"four_texture":"res://Sprites/Dice/4 buff defence dice.png",
	"price":25,
	"upgrade_level":0,
	"animation_target":"self",
	"type":Dice.DiceType.DEFBUFF,
	"effect":Status_Library.StatusCondition.DEFBUFF,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Buff Defence Dice",
	"description":"Buff your defence x1.5 for 3 turns"
	}
var debuff_attack_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"dba_dice",
	"texture":"res://Sprites/Dice/one debuff attack dice.png",
	"none_texture":"res://Sprites/Dice/none debuff dice.png",
	"two_texture":"res://Sprites/Dice/2 debuff attack dice.png",
	"three_texture":"res://Sprites/Dice/3 debuff attack dice.png",
	"four_texture":"res://Sprites/Dice/4 debuff attack dice.png",
	"price":20,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.ATKDEBUFF,
	"effect":Status_Library.StatusCondition.ATKDEBUFF,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Debuff Attack Dice",
	"description":"Debuff enemy attack x1.5 for 3 turns"
	}
var debuff_defence_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"dbd_dice",
	"texture":"res://Sprites/Dice/one debuff defence dice.png",
	"none_texture":"res://Sprites/Dice/none debuff dice.png",
	"two_texture":"res://Sprites/Dice/2 debuff defence dice.png",
	"three_texture":"res://Sprites/Dice/3 debuff defence dice.png",
	"four_texture":"res://Sprites/Dice/4 debuff defence dice.png",
	"price":20,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.DEFDEBUFF,
	"effect":Status_Library.StatusCondition.DEFDEBUFF,
	"element":Dice.DamageElement.NONE,
	"is_temp":false,
	"long_name":"Debuff Defence Dice",
	"description":"Debuff enemy defence x1.5 for 3 turns"
	}
var fire_dice_shop_data:Dictionary = {
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
	"is_temp":false,
	"long_name":"Fire Dice",
	"description":"deal fire type damage to an enemy and has a 50% chance to burn for 3 turns"
	}
var ice_dice_shop_data:Dictionary = {
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
	"is_temp":false,
	"long_name":"Ice Dice",
	"description":"deal half your attack as ice type damage to an enemy, has a 20% chance to freeze"
	}
var lightning_dice_shop_data:Dictionary = {
	"item_code":0,
	"item_name":"lig_dice",
	"texture":"res://Sprites/Dice/one lightning dice.png",
	"none_texture":"res://Sprites/Dice/none lightning dice.png",
	"two_texture":"res://Sprites/Dice/2 lightning dice.png",
	"three_texture":"res://Sprites/Dice/3 lightning dice.png",
	"four_texture":"res://Sprites/Dice/4 lightning dice.png",
	"price":40,
	"upgrade_level":0,
	"animation_target":"target",
	"type":Dice.DiceType.LIGHTNING,
	"effect":false,
	"element":Dice.DamageElement.LIGHTNING,
	"is_temp":false,
	"long_name":"Lightning Dice",
	"description":"deal lightning type damage to an enemy, deals half damage to other enemies"
	}
var none_dice_shop_data:Dictionary = {#Mainly for trap battle key
	"item_code":0,
	"item_name":"non_dice",
	"texture":"res://Sprites/Dice/blank dice template.png",
	"none_texture":"res://Sprites/Dice/blank dice template.png",
	"price":0,
	"upgrade_level":0,
	"animation_target":"",
	"type":Dice.DiceType.NONE,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"long_name":"None Dice",
	"description":"not meant to be playeble"
	}

var all_dice:Dictionary = {
	"atk_dice":attack_dice_shop_data,
	"def_dice":defend_dice_shop_data,
	"rrl_dice":reroll_dice_shop_data,
	"bld_dice":bleed_dice_shop_data,
	"hel_dice":heal_dice_shop_data,
	"gld_dice":gold_dice_shop_data,
	"ref_dice":reflect_dice_shop_data,
	"lfs_dice":lifesteal_dice_shop_data,
	"poi_dice":poison_dice_shop_data,
	"cur_dice":cure_dice_shop_data,
	"stn_dice":stun_dice_shop_data,
	"dis_dice":disarm_dice_shop_data,
	"bfa_dice":buff_attack_dice_shop_data,
	"bfd_dice":buff_defence_dice_shop_data,
	"dba_dice":debuff_attack_dice_shop_data,
	"dbd_dice":debuff_defence_dice_shop_data,
	"fir_dice":fire_dice_shop_data,
	"ice_dice":ice_dice_shop_data,
	"lig_dice":lightning_dice_shop_data
	}

func get_dice_data(dice_name:String):
	return all_dice[dice_name]
			

func default_checker(dice_data:Dictionary):
	var default:bool = false
	for die in all_dice.values():
		if !default:
			if dice_data == die:
				default = true
	return default
			
func get_dice_type(dice_name:String):
	var ref_dice = all_dice[dice_name]
	return ref_dice["type"]
func get_sprite_from_type(dice_type:Dice.DiceType):
	var send_texture = ""
	match dice_type:
		Dice.DiceType.ATTACK:
			send_texture = "res://Sprites/Dice/attack dice template.png"
		Dice.DiceType.DEFEND:
			send_texture = "res://Sprites/Dice/defend dice template.png"
		Dice.DiceType.REROLL:
			send_texture = "res://Sprites/Dice/reroll dice template.png"
		Dice.DiceType.BLEED:
			send_texture = "res://Sprites/Dice/bleed dice template.png"
		Dice.DiceType.HEAL:
			send_texture = "res://Sprites/Dice/heal dice template.png"
		Dice.DiceType.GOLD:
			send_texture = "res://Sprites/Dice/none gold dice.png"
		Dice.DiceType.REFLECT:
			send_texture = "res://Sprites/Dice/none reflect dice.png"
		Dice.DiceType.LIFESTEAL:
			send_texture = "res://Sprites/Dice/none lifesteal dice.png"
		Dice.DiceType.POISON:
			send_texture = "res://Sprites/Dice/none poison dice.png"
		Dice.DiceType.CURE:
			send_texture = "res://Sprites/Dice/none cure dice.png"
		Dice.DiceType.DISARM:
			send_texture = "res://Sprites/Dice/none disarm dice.png"
		Dice.DiceType.STUN:
			send_texture = "res://Sprites/Dice/none stun dice.png"
		Dice.DiceType.ATKBUFF:
			send_texture = "res://Sprites/Dice/none buff dice.png"
		Dice.DiceType.DEFBUFF:
			send_texture = "res://Sprites/Dice/none buff dice.png"
		Dice.DiceType.ATKDEBUFF:
			send_texture = "res://Sprites/Dice/none debuff dice.png"
		Dice.DiceType.DEFDEBUFF:
			send_texture = "res://Sprites/Dice/none debuff dice.png"
		Dice.DiceType.FIRE:
			send_texture = "res://Sprites/Dice/none fire dice.png"
		Dice.DiceType.ICE:
			send_texture = "res://Sprites/Dice/none ice dice.png"
		Dice.DiceType.LIGHTNING:
			send_texture = "res://Sprites/Dice/none lightning dice.png"
		Dice.DiceType.NONE:
			send_texture = "res://Sprites/Dice/blank dice template.png"
			
	return send_texture
	
