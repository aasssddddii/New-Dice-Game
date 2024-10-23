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


var dice_pack_data:Dictionary = {
	"item_code":2,
	"item_name":"die_pack",
	"texture":"res://Sprites/shop/specialty_shops/dice_pack_item.png",
	"price":80,
	"long_name":"Dice Pack",
	"description":"Open the pack for 3 random dice"
	}
var potion_data:Dictionary = {
	"item_code":2,
	"item_name":"hea_potion",
	"texture":"res://Sprites/shop/specialty_shops/health_potion_item.png",
	"price":20,
	"long_name":"Health Potion",
	"description":"Heal 25% Health"
	}
var bomb_data:Dictionary = {
	"item_code":2,
	"item_name":"ite_bomb",
	"texture":"res://Sprites/shop/specialty_shops/bomb_item.png",
	"price":50,
	"long_name":"Bomb",
	"description":"Deal 30 Damage to all enemies (Can only use in combat)"
	}
	
var all_items:Dictionary = {
	"die_pack":dice_pack_data,
	"hea_potion":potion_data,
	"ite_bomb":bomb_data
}
func get_item_data(name:String):
	return all_items[name]
