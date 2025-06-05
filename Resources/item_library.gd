extends Resource
class_name Item_lib




var attack_upgrade_data:Dictionary = {
	"item_code":1,
	"item_name":"atk_upgrade",
	"texture":"res://Sprites/shop/specialty_shops/attack skill upgrade.png",
	"price":10,
	"long_name":"Basic Attack Increase",
	"description":"Train your basic attack to beat stronger enemies"
	}
var defend_upgrade_data:Dictionary = {
	"item_code":1,
	"item_name":"def_upgrade",
	"texture":"res://Sprites/shop/specialty_shops/defend skill upgrade.png",
	"price":5,
	"long_name":"Basic Defence Increase",
	"description":"Train your basic defence to gain a larger shield"
	}
var heal_upgrade_data:Dictionary = {
	"item_code":1,
	"item_name":"hel_upgrade",
	"texture":"res://Sprites/shop/specialty_shops/heal skill upgrade.png",
	"price":5,
	"long_name":"Basic Heal Increase",
	"description":"Train your basic Heal to heal more per dice"
	}
var discard_slot_upgrade_data:Dictionary = {
	"item_code":1,
	"item_name":"discard_slot",
	"texture":"res://Sprites/shop/specialty_shops/discard slot.png",
	"price":80,
	"long_name":"discard slot",
	"description":"adds discard slot to your dice game board"
	}
var all_shop_skills:Dictionary = {
	"atk_upgrade":attack_upgrade_data,
	"def_upgrade":defend_upgrade_data,
	"hel_upgrade":heal_upgrade_data,
	"discard_slot":discard_slot_upgrade_data
	}
func get_skill_data(name:String):
	return all_shop_skills[name]

#enum UsageType {
#	MAP,0
#	COMBAT,1
#	ALL,2
#}

var dice_pack_data:Dictionary = {
	"item_code":2,
	"item_name":"die_pack",
	"texture":"res://Sprites/shop/specialty_shops/dice_pack_item.png",
	"price":80,
	"use_type":0,
	"long_name":"Dice Pack",
	"description":"Open the pack for 3 random dice"
	}
var potion_data:Dictionary = {
	"item_code":2,
	"item_name":"hea_potion",
	"texture":"res://Sprites/shop/specialty_shops/health_potion_item.png",
	"price":20,
	"use_type":2,
	"long_name":"Health Potion",
	"description":"Heal 25% Health"
	}
var bomb_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_bomb",
	"texture":"res://Sprites/shop/specialty_shops/bomb_item.png",
	"price":50,
	"use_type":1,
	"long_name":"Bomb",
	"description":"Deal 30 Damage to all enemies (Can only use in combat)"
	}
var rage_buff_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_rage",
	"texture":"res://Sprites/shop/items/damage potion.png",
	"price":50,
	"use_type":2,
	"long_name":"rage potion",
	"description":"Give player attack stat boost for 3 battles"
	}
var cure_potion_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_cure",
	"texture":"res://Sprites/shop/items/cure potion.png",
	"price":20,
	"use_type":1,
	"long_name":"cure potion",
	"description":" this potion cures all negative status effects when used"
	}
var heal_power_potion_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_help",
	"texture":"res://Sprites/shop/items/health potion.png",
	"price":0,
	"use_type":2,
	"long_name":"heal power potion",
	"description":"this potion buffs your heal power for 3 battles"
	}
var shield_power_potion_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_ship",
	"texture":"res://Sprites/shop/items/shield potion.png",
	"price":0,
	"use_type":2,
	"long_name":"shield power potion",
	"description":"this potion buffs your shiled power for 3 battles"
	}
var trap_disarmer_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_trad",
	"texture":"res://Sprites/shop/items/trap disarmer.png",
	"price":0,
	"use_type":1,
	"long_name":"trap disarmer",
	"description":"disarms traps completing the key and rendering it useless"
	}
var dictated_fate_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_dicf",
	"texture":"res://Sprites/shop/items/dictated fate.png",
	"price":0,
	"use_type":1,
	"long_name":"dictated fate dice",
	"description":"set one dice to its highest value"
	}
var rewind_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_rewi",
	"texture":"res://Sprites/shop/items/rewind.png",
	"price":0,
	"use_type":1,
	"long_name":"rewind",
	"description":"reroll all dice in hand"
	}
var fate_fragment_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_fatf",
	"texture":"res://Sprites/shop/items/fate fragment.png",
	"price":0,
	"use_type":1,
	"long_name":"fate fragment",
	"description":"discard one dice and draw 2"
	}
var forge_core_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_forc",
	"texture":"res://Sprites/shop/items/forge core.png",
	"price":0,
	"use_type":0,
	"long_name":"forge core",
	"description":"upgrade one dice by one stage"
	}
var smokescreen_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_smok",
	"texture":"res://Sprites/shop/items/smokescreen.png",
	"price":0,
	"use_type":1,
	"long_name":"smokescreen",
	"description":"adds possibility for enemy to miss"
	}
var disarm_dust_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_disd",
	"texture":"res://Sprites/shop/items/disarm dust.png",
	"price":0,
	"use_type":1,
	"long_name":"disarm dust",
	"description":"disarms targeted enemy"
	}
var weakness_dust_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_wead",
	"texture":"res://Sprites/shop/items/weakness dust.png",
	"price":0,
	"use_type":1,
	"long_name":"weakness dust",
	"description":"makes targeted enemy's attacks weaker"
	}
var coconut_candy_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_cocc",
	"texture":"res://Sprites/shop/items/coconut candy.png",
	"price":0,
	"use_type":1,
	"long_name":"coconut candy",
	"description":"doubles values of submit dice"
	}
var onearm_tie_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_onet",
	"texture":"res://Sprites/shop/items/one arm tie.png",
	"price":0,
	"use_type":1,
	"long_name":"one-arm tie",
	"description":"makes targeted enemy take one less action per turn"
	}
var mimic_shard_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_mims",
	"texture":"res://Sprites/shop/items/mimic shard.png",
	"price":0,
	"use_type":1,
	"long_name":"mimic shard",
	"description":"copy attack dice of any enemy and roll it for yourself"
	}
var aegis_coin_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_aegc",
	"texture":"res://Sprites/shop/items/aegis coin.png",
	"price":0,
	"use_type":1,
	"long_name":"aegis coin",
	"description":"nullifies all damage for one turn"
	}
	
var all_items:Dictionary = {
	"die_pack":dice_pack_data,
	"hea_potion":potion_data,
	"ite_bomb":bomb_data,
	"ite_rage":rage_buff_data,
	"ite_cure":cure_potion_data,
	"ite_help":heal_power_potion_data,
	"ite_ship":shield_power_potion_data,
	"ite_trad":trap_disarmer_data,
	"ite_dicf":dictated_fate_data,
	"ite_rewi":rewind_data,
	"ite_fatf":fate_fragment_data,
	"ite_forc":forge_core_data,
	"ite_smok":smokescreen_data,
	"ite_disd":disarm_dust_data,
	"ite_wead":weakness_dust_data,
	"ite_cocc":coconut_candy_data,
	"ite_onet":onearm_tie_data,
	"ite_mims":mimic_shard_data,
	"ite_aegc":aegis_coin_data
}
func get_item_data(name:String):
	return all_items[name]



var health_stat:Dictionary = {
	"item_code":3,
	"item_name":"sta_health",
	"long_name":"health",
	"description":"Your current health is in red and your max health is in pink (hover over heart to see max)"
	}
var attack_stat:Dictionary = {
	"item_code":3,
	"item_name":"sta_attack",
	"long_name":"attack power",
	"description":"the current strength of your attack rolls"
	}
var shield_stat:Dictionary = {
	"item_code":3,
	"item_name":"sta_shield",
	"long_name":"shield power",
	"description":"the current strength of your defend rolls"
	}
var heal_power_stat:Dictionary = {
	"item_code":3,
	"item_name":"sta_heal",
	"long_name":"heal power",
	"description":"the current strength of your heal rolls"
	}
var gold_stat:Dictionary = {
	"item_code":3,
	"item_name":"sta_gold",
	"long_name":"gold",
	"description":"the current amount of gold you have"
	}
	
#Charms
var hp_up_data:Dictionary = {
	"item_code":4,
	"item_name":"cha_hpup",
	"texture":"res://Sprites/charms/HP up.png",
	"long_name":"+max hp",
	"description":"increases current max hp"
}
var shop_coupon_data:Dictionary = {
	"item_code":4,
	"item_name":"cha_coupon",
	"texture":"res://Sprites/charms/shop_coupon.png",
	"long_name":"shop coupon",
	"description":"provides a 5% off all shop items up to 50%"
}
var attack_shields_data:Dictionary = {
	"item_code":4,
	"item_name":"cha_atks",
	"texture":"res://Sprites/charms/attacks_shield.png",
	"long_name":"Offensive Defence",
	"description":"all attack will also provide one shield stack"
}

var all_charms:Dictionary = {
	"cha_hpup":hp_up_data,
	"cha_coupon":shop_coupon_data,
	"cha_atks":attack_shields_data
}
func get_charm_data(name:String):
	return all_charms[name]
