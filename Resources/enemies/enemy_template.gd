extends Resource
class_name enemy_resource

enum TurnActions {
	ATTACK,
	DEFEND,
	HEAL,
	NONE
}
@export var enemy_name:String
@export var enemy_description:String
@export var max_health:int
@export var health:int
@export var shield:int 
@export var heal_power:int
@export var attack:int
@export var defend:int
@export var attacks:int
@export var reward_gold:int

@export var basic_attack_damage_type:Dice.DamageElement = Dice.DamageElement.NONE


@export var weaknesses:Dictionary = {
	Dice.DamageElement.FIRE:false,
	Dice.DamageElement.ICE:false,
	Dice.DamageElement.LIGHTNING:false,
	Dice.DamageElement.POISON:false,
	Dice.DamageElement.BLEED:false
}
@export var resistantses:Dictionary = {
	Dice.DamageElement.FIRE:false,
	Dice.DamageElement.ICE:false,
	Dice.DamageElement.LIGHTNING:false,
	Dice.DamageElement.POISON:false,
	Dice.DamageElement.BLEED:false
}



@export var attack_texture:Texture
@export var defend_texture:Texture
@export var heal_texture:Texture
@export var blank_texture:Texture
@export var main_texture:Texture


@export var possible_turn_actions:Array[TurnActions] = [
	TurnActions.ATTACK,
	TurnActions.DEFEND,
	TurnActions.NONE
]




	
	
	
	
