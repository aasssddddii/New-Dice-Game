extends Node



var player_resource
var player_prefab = preload("res://Prefabs/game_map/player.tscn")
@onready var status_lib:Resource = preload("res://Resources/status_library.tres")
var enemy_lib = preload("res://Resources/enemies/enemy_library.tres")
var dice_battle_prefab = preload("res://Scenes/dice_battle.tscn")
var ui_shop_prefab = preload("res://Prefabs/shop/ui_shop.tscn")
var dice_lib = preload("res://Resources/dice_library.tres")
var item_lib = preload("res://Resources/item_library.tres")
var item_prefab = preload("res://Prefabs/shop_item.tscn")
var picture_item_prefab = preload("res://Prefabs/picture_item.tscn")
var ui_battle_summary = preload("res://Prefabs/game_ui/ui_battle_summary.tscn")
var poi_lib = preload("res://Resources/poi_library.tres")
var level_selection_template = preload("res://Prefabs/new_game_map/level_selection_template.tscn")
var discard_event_prefab = preload("res://Prefabs/event/dice_altar.tscn")
var ui_event = preload("res://Prefabs/event/ui_event.tscn")
#player menu
var player_inventory_menu = preload("res://Prefabs/new_game_map/player_inventory_menu.tscn")


var rng = RandomNumberGenerator.new()

func _ready():
	player_resource = load("res://Resources/player_resource.tres")
	player_resource.reset_values()
	# IDEA of how to implement charms
#	add_charm("cha_hpup")
#	add_charm("cha_shla")
#	add_charm("cha_salv")
#	add_charm("cha_toxi")
	#add_charm("cha_toxi")
	#add_charm("cha_toxi")
	add_charm("cha_mega")
	add_charm("cha_iron")
	add_charm("cha_fire")
	add_charm("cha_blee")
	add_charm("cha_pois")
	add_charm("cha_ligh")
	add_charm("cha_icer")
	add_charm("cha_inve")
	add_skill("action_slot")
	add_skill("swee_upgrade")
	add_skill("layh_upgrade")
	add_skill("swag_upgrade")
	add_skill("seco_upgrade")
#	add_skill("emer_upgrade")
#	add_skill("char_upgrade")
		
#func default_checker(input_data):
#	if dice_lib.all_dice[input_data["item_name"]] == input_data:
#		return true
#	else:
#		return false
	
func add_charm(charm_name:String):
	player_resource.charm_inventory.append(item_lib.get_charm_data(charm_name))
	match charm_name:
		"cha_hpup":
			player_resource.max_health += 20
			player_resource.health += 20
		"cha_atks":
			player_resource.atk_shield += 1
		"cha_shla":
			player_resource.shl_attack +=1
		"cha_salv":
			player_resource.salvage_tool +=1
		"cha_shie":
			player_resource.shield_up +=1
		"cha_heal":
			player_resource.heal_up +=1
		"cha_corn":
			player_resource.cornicopia_draw +=1
		"cha_medi":
			player_resource.meditate +=1
		"cha_gold":
			player_resource.battle_gold +=1
		"cha_medc":
			player_resource.cure_heal += 1
		"cha_pier":
			player_resource.piercing += 1
		"cha_thor":
			player_resource.thorns += 1
		"cha_toxi":
			player_resource.toxic_orb += 1
		"cha_mega":
			player_resource.mega_debuff +=1
		"cha_vamp":
			player_resource.vamp_thread +=1
		"cha_iron":
			player_resource.iron_root +=1
		"cha_fire":
			player_resource.fire_resist += 1
		"cha_blee":
			player_resource.bleed_resist += 1
		"cha_pois":
			player_resource.poison_resist += 1
		"cha_ligh":
			player_resource.lightning_resist += 1
		"cha_icer":
			player_resource.ice_resist += 1
		"cha_inve":
			player_resource.investment += 1
		_:
			print("Charm not setup yet: game_manager.gd")
	
func add_skill(skill_name:String):
	player_resource.skills_inventory.append(item_lib.get_skill_data(skill_name))
	match skill_name:
		"action_slot":
			player_resource.action_slot_upgrade = true
		"swee_upgrade":
			player_resource.sweeping_edge_upgrade = true
		"layh_upgrade":
			player_resource.lay_on_hands_upgrade = true
		"swag_upgrade":
			player_resource.swagger_upgrade = true
		"seco_upgrade":
			player_resource.second_skin_upgrade = true
		"emer_upgrade":
			player_resource.emergency_cache_upgrade = true
		"char_upgrade":
			player_resource.charm_sync_upgrade = true
	
