extends Resource
class_name Status_Library

enum StatusCondition{
	BLEED,
	BURN,
	POISON,
	SLEEP,
	REFLECT,
	FROZEN,
	ATKBUFF,
	DEFBUFF,
	ATKDEBUFF,
	DEFDEBUFF,
	STUN,
	CURE,
	DISARM
}

var status_prefab:PackedScene = load("res://Prefabs/game_ui/status_template.tscn")


@export var bleed_status_data:Dictionary = {
	"name":"bleed",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/bleed status.png",
	"status_condition":StatusCondition.BLEED,
	"turns":3,
	"damage":3
}
@export var reflect_status_data:Dictionary = {
	"name":"reflect",
	"is_positive":true,
	"texture":"res://Sprites/status_conditions/reflect status.png",
	"status_condition":StatusCondition.REFLECT,
	"turns":-1
}
@export var disarm_status_data:Dictionary = {
	"name":"disarm",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/disarm status.png",
	"status_condition":StatusCondition.DISARM,
	"turns":3,
	"damage":0
}
@export var stun_status_data:Dictionary = {
	"name":"stun",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/stun status.png",
	"status_condition":StatusCondition.STUN,
	"turns":0,#maybe change to 0
	"damage":0
}
@export var poison_status_data:Dictionary = {
	"name":"poison",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/poison status.png",
	"status_condition":StatusCondition.POISON,
	"turns":3,
	"damage":5
}
@export var frozen_status_data:Dictionary = {
	"name":"frozen",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/frozen status.png",
	"status_condition":StatusCondition.FROZEN,
	"turns":1,
	"damage":0
}
@export var attack_buff_status_data:Dictionary = {
	"name":"atk_buff",
	"is_positive":true,
	"texture":"res://Sprites/status_conditions/attack buff status.png",
	"status_condition":StatusCondition.ATKBUFF,
	"turns":3
}
@export var attack_debuff_status_data:Dictionary = {
	"name":"atk_debuff",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/attack debuff status.png",
	"status_condition":StatusCondition.ATKDEBUFF,
	"turns":3,
	"damage":0
}
@export var defence_buff_status_data:Dictionary = {
	"name":"def_buff",
	"is_positive":true,
	"texture":"res://Sprites/status_conditions/defence buff status.png",
	"status_condition":StatusCondition.DEFBUFF,
	"turns":3
}
@export var defence_debuff_status_data:Dictionary = {
	"name":"def_debuff",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/defence debuff status.png",
	"status_condition":StatusCondition.DEFDEBUFF,
	"turns":3,
	"damage":0
}
@export var cure_status_data:Dictionary = {
	"name":"cure",
	"is_positive":true,
	"texture":"res://Sprites/status_conditions/cure status.png",
	"status_condition":StatusCondition.CURE,
	"turns":3
}
@export var burn_status_data:Dictionary = {
	"name":"fire",
	"is_positive":false,
	"texture":"res://Sprites/status_conditions/fire status.png",
	"status_condition":StatusCondition.BURN,
	"turns":3,
	"damage":5
}




func get_status_data(status_condition:StatusCondition):
	match status_condition:
		StatusCondition.REFLECT:
			return reflect_status_data
		StatusCondition.DISARM:
			return disarm_status_data
		StatusCondition.STUN:
			return stun_status_data
		StatusCondition.POISON:
			return poison_status_data
		StatusCondition.BLEED:
			return bleed_status_data
		StatusCondition.FROZEN:
			return frozen_status_data
		StatusCondition.ATKBUFF:
			return attack_buff_status_data
		StatusCondition.ATKDEBUFF:
			return attack_debuff_status_data
		StatusCondition.DEFBUFF:
			return defence_buff_status_data
		StatusCondition.DEFDEBUFF:
			return defence_debuff_status_data
		StatusCondition.CURE:
			return cure_status_data
		StatusCondition.BURN:
			return burn_status_data
		_:
			print("Error on status library - Status not implemented")

