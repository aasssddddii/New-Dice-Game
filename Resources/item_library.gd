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
var action_slot_upgrade_data:Dictionary = {
	"item_code":1,
	"item_name":"action_slot",
	"texture":"res://Sprites/shop/skill upgrade/action slot.png",
	"price":200,
	"long_name":"action slot",
	"description":"adds one action slot to your dice game board"
	}
var sweeping_edge_data:Dictionary = {
	"item_code": 1,
	"item_name": "swee_upgrade",
	"texture": "res://Sprites/shop/skill upgrade/sweeping edge.png",
	"price":20,
	"long_name": "Sweeping edge",
	"description": "Basic attacks deal Aoe damage"
}
var lay_on_hands_data:Dictionary = {
	"item_code": 1,
	"item_name": "layh_upgrade",
	"texture": "res://Sprites/shop/skill upgrade/lay on hands.png",
	"price":20,
	"long_name": "Lay hands",
	"description": "Heal Dice will also cure"
}
var swagger_data:Dictionary = {
	"item_code": 1,
	"item_name": "swag_upgrade",
	"texture": "res://Sprites/shop/skill upgrade/swagger_transparent.png",
	"price":20,
	"long_name": "Swagger",
	"description": "gain +1 action when enemy is killed"
}
var second_skin_data:Dictionary = {
	"item_code": 1,
	"item_name": "seco_upgrade",
	"texture": "res://Sprites/shop/skill upgrade/second skin.png",
	"price":20,
	"long_name": "Second Skin",
	"description": "The first hit of each battle deals half damage."
}
var emergency_cache_data:Dictionary = {
	"item_code": 1,
	"item_name": "emer_upgrade",
	"texture": "res://Sprites/shop/skill upgrade/emergency cache.png",
	"price":20,
	"long_name": "Emergency Cache",
	"description": "Gain a single-use item at the start of every battle."
}
var charm_sync_data:Dictionary = {
	"item_code": 1,
	"item_name": "char_upgrade",
	"texture": "res://Sprites/shop/skill upgrade/charm sync.png",
	"price":20,
	"long_name": "Charm Sync",
	"description": "gain Max HP for every 5 charms"
}
var all_shop_skills:Dictionary = {
	"atk_upgrade":attack_upgrade_data,
	"def_upgrade":defend_upgrade_data,
	"hel_upgrade":heal_upgrade_data,
	"action_slot":action_slot_upgrade_data,
	"swee_upgrade":sweeping_edge_data,
	"layh_upgrade":lay_on_hands_data,
	"swag_upgrade":swagger_data,
	"seco_upgrade":second_skin_data,
	"emer_upgrade":emergency_cache_data,
	"char_upgrade":charm_sync_data
	}
var all_basic_skills:Dictionary = {
	"atk_upgrade":attack_upgrade_data,
	"def_upgrade":defend_upgrade_data,
	"hel_upgrade":heal_upgrade_data
	}
var all_skill_upgrades:Dictionary = {
	"action_slot":action_slot_upgrade_data,
	"swee_upgrade":sweeping_edge_data,
	"layh_upgrade":lay_on_hands_data,
	"swag_upgrade":swagger_data,
	"seco_upgrade":second_skin_data,
	"emer_upgrade":emergency_cache_data,
	"char_upgrade":charm_sync_data
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
	"use_type":1,
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
	"description":"this potion buffs your heal power for 3 turns"
	}
var shield_power_potion_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_ship",
	"texture":"res://Sprites/shop/items/shield potion.png",
	"price":0,
	"use_type":2,
	"long_name":"shield power potion",
	"description":"this potion buffs your shiled power for 3 turns"
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
	"description":"upgrade three dice by one stage"
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
var action_up_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_actu",
	"texture":"res://Sprites/shop/items/Action up.png",
	"price":0,
	"use_type":1,
	"long_name":"action up",
	"description":"gives you one extra action slot for 3 turns"
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

var player_shop_coin_data:Dictionary = {
	"item_code":5,
	"item_name":"ite_pcoi",
	"texture":"res://Sprites/shop/items/player_gold.png",
	"price":0,
	"use_type":1,
	"coin_amount":0,
	"long_name":"player coin",
	"description":"allows player to pay for shop items with gold"
	}

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
	"max":-1,
	"long_name":"+max hp",
	"description":"increases current max hp"
}
var shop_coupon_data:Dictionary = {
	"item_code":4,
	"item_name":"cha_coupon",
	"texture":"res://Sprites/charms/shop_coupon.png",
	"max":10,
	"long_name":"shop coupon",
	"description":"provides a 5% off all shop items up to 50%"
}
var attack_shields_data:Dictionary = {
	"item_code":4,
	"item_name":"cha_atks",
	"texture":"res://Sprites/charms/attacks_shield.png",
	"max":-1,
	"long_name":"Offensive Defence",
	"description":"all attack will also provide one shield stack"
}
var shields_attack_data:Dictionary = {
	"item_code":4,
	"item_name":"cha_shla",
	"texture":"res://Sprites/charms/shields_attack.png",
	"max":-1,
	"long_name":"Faux defences",
	"description":"all defend dice will also provide one attack stack"
}
var salvage_tool_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_salv",
	"texture": "res://Sprites/charms/salvage tool.png",
	"max":-1,
	"long_name": "Salvage Tool",
	"description": "used zero dice still provides something instead of 0"
}
var shield_up_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_shie",
	"texture": "res://Sprites/charms/Shield up.png",
	"max":-1,
	"long_name": "Shield UP",
	"description": "buffs your shield power in battle"
}
var heal_up_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_heal",
	"texture": "res://Sprites/charms/heal power up.png",
	"max":-1,
	"long_name": "Heal power UP",
	"description": "buffs your heal power in battle"
}
var fire_resist_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_fire",
	"texture": "res://Sprites/charms/fire resist.png",
	"max":3,
	"long_name": "Fire resist",
	"description": "A charm that provides some resistance to fire damage"
}
var lightning_resist_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_ligh",
	"texture":"res://Sprites/charms/lightning resist.png" ,
	"max":3,
	"long_name": "Lightning resist",
	"description": "A charm that provides some resistance to Lightning damage"
}
var ice_resist_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_icer",
	"texture": "res://Sprites/charms/ice resist.png",
	"max":3,
	"long_name": "Ice resist",
	"description": "A charm that provides some resistance to Ice damage"
}
var bleed_resist_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_blee",
	"texture": "res://Sprites/charms/bleed resist.png",
	"max":3,
	"long_name": "bleed resist",
	"description": "A charm that provides some resistance to bleed damage"
}
var poison_resist_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_pois",
	"texture": "res://Sprites/charms/poison resist.png",
	"max":3,
	"long_name": "poison resist",
	"description": "A charm that provides some resistance to poison damage"
}
var Cornicopia_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_corn",
	"texture": "res://Sprites/charms/extra draw charm.png",
	"max":3,
	"long_name": "Cornicopia",
	"description": "Chance to +1 Draw dice in dice battle"
}
var meditate_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_medi",
	"texture": "res://Sprites/charms/meditate.png",
	"max":-1,
	"long_name": "Meditate",
	"description": "Heal on attack with no dice"
}
var golden_die_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_gold",
	"texture": "res://Sprites/charms/extra gold .png",
	"max":-1,
	"long_name": "Golden Die",
	"description": "gain extra gold per battle"
}
var medic_inspiration_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_medc",
	"texture": "res://Sprites/charms/cure dice heal.png",
	"max":1,
	"long_name": "Medic inspiration",
	"description": "Cure Dice also Heal more stacks heals more"
}
var piercing_chain_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_pier",
	"texture": "res://Sprites/charms/piercing chain.png",
	"max":3,
	"long_name": "Piercing Chain",
	"description": "attacks deals damage to shield and Health"
}
var thorns_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_thor",
	"texture": "res://Sprites/charms/thorns charm.png",
	"max":3,
	"long_name": "Thorns",
	"description": "when hit deals a portion of damage to that enemy"
}
var toxic_orb_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_toxi",
	"texture": "res://Sprites/charms/toxic_orb.png",
	"max":1,
	"long_name": "Toxic orb",
	"description": "poison damage you deal heals you"
}
var mega_buff_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_mega",
	"texture": "res://Sprites/charms/debuff damage.png",
	"max":1,
	"long_name": "Mega Debuff",
	"description": "Debuff Dice Deal Damage, more stacks deals more damage"
}
var investment_prorgative_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_inve",
	"texture": "res://Sprites/charms/skill buff upgrade.png",
	"max":-1,
	"long_name": "Investment prorgative",
	"description": "skill upgrades will give more amount per upgrade"
}
var vampiric_thread_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_vamp",
	"texture": "res://Sprites/charms/vamperic thread.png",
	"max":3,
	"long_name": "Vampiric Thread",
	"description": "Heal on enemy kill, Heal amount increases with stacks."
}
var iron_root_data:Dictionary = {
	"item_code": 4,
	"item_name": "cha_iron",
	"texture": "res://Sprites/charms/iron root.png",
	"max":1,
	"long_name": "Iron Root Charm",
	"description": "+2 Max HP on battle clear when full, but heals +2 otherwise"
}
var all_charms:Dictionary = {
	"cha_hpup":hp_up_data,
	"cha_coupon":shop_coupon_data,
	"cha_atks":attack_shields_data,
	"cha_salv":salvage_tool_data,
	"cha_shie":shield_up_data,
	"cha_heal":heal_up_data,
	"cha_fire":fire_resist_data,
	"cha_ligh":lightning_resist_data,
	"cha_icer":ice_resist_data,
	"cha_blee":bleed_resist_data,
	"cha_pois":poison_resist_data,
	"cha_corn":Cornicopia_data,
	"cha_medi":meditate_data,
	"cha_gold":golden_die_data,
	"cha_medc":medic_inspiration_data,
	"cha_pier":piercing_chain_data,
	"cha_thor":thorns_data,
	"cha_toxi":toxic_orb_data,
	"cha_mega":mega_buff_data,
	"cha_inve":investment_prorgative_data,
	"cha_vamp":vampiric_thread_data,
	"cha_iron":iron_root_data,
	"cha_shla":shields_attack_data
	
}
func get_charm_data(name:String):
	return all_charms[name]
