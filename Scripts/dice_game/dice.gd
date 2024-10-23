extends TextureButton
class_name Dice

const offset =  Vector2(-28,-28)

enum DiceType {
	ATTACK,
	DEFEND,
	REROLL,
	BLEED,
	HEAL,
	GOLD,
	REFLECT,
	LIFESTEAL,
	POISON,
	CURE,
	DISARM,
	STUN,
	ATKBUFF,
	DEFBUFF,
	ATKDEBUFF,
	DEFDEBUFF,
	FIRE,
	ICE,
	LIGHTNING,
	NONE
}
enum DamageElement{
	FIRE,
	ICE,
	LIGHTNING,
	POISON,
	WATER,
	BLEED,
	NONE
}

var current_sprite


var dice_data:Dictionary = {
#	"item_code":int,
#	"item_name":String,
#	"texture":String,
#	"none_texture":String,
#	"price":int,
#	"upgrade_price":int,
#	"animation_target":String,
#	"type":Dice.DiceType,
#	"effect":bool,
#	"element":DamageElement,
#	"faces":Array[int],
#	"long_name":String,
#	"description":String

}
@onready var area = get_node_or_null("dice_area")
@onready var button = get_node_or_null("Dice")
@onready var dice_sprite = get_node_or_null("Sprite2D")
@onready var player_bar_node = get_node_or_null("../../../player_bar")


var is_grabbing:bool = false
var overlaping_bodies
var overlap_dice
var snap_area
var last_snap_area
var is_on_dice:bool = false


var up_face:int
var upgrade_level



func _physics_process(delta):
	if Input.is_action_just_released("mouse_click_up"):
		is_grabbing = false
	if snap_area:
		if !is_grabbing && global_position != snap_area.global_position:
			global_position = snap_area.global_position + offset
		
	if is_grabbing:
		global_position = get_global_mouse_position() + offset
		
func get_current_snap_area():
	area.area_entered.connect(func set_snap_area(entered_area:Area2D):
		if entered_area.is_in_group("dice_snap"):
			if !entered_area.is_filled:
				if last_snap_area != snap_area:
					last_snap_area = snap_area
				snap_area = entered_area
		)
	if snap_area:
		return true
	else:
		return false

func go_to_last_snap():
	if snap_area:
		global_position = snap_area.global_position + offset
	else:
		global_position = last_snap_area.global_position + offset


func set_dice_data(data:Dictionary):
	dice_data = data
	name = dice_data["item_name"]
	roll()
	

func roll():
	#print("rolling dice: ", name)
	
	up_face = dice_data["faces"].pick_random()
	match up_face:
		0:
			texture_normal = load(dice_data["none_texture"])
		1:
			texture_normal = load(dice_data["texture"])
		_:
			print("not implemented in faces: dice.gd")
	
	

#func _on_dice_area_area_entered(area):
#	print(name, " dice now overlapping area ", area)
#	if area.is_in_group("dice_snap"):
#			if !area.is_filled:
#				if last_snap_area != snap_area:
#					last_snap_area = snap_area
#				snap_area = area
#


func _on_button_down():
	if get_current_snap_area():
		snap_area.filler(self)
		
	if player_bar_node != null:
		if !player_bar_node.enemy_taking_turn:
			is_grabbing = true 
	else:
		is_grabbing = true


func _on_button_up():
	if get_current_snap_area():
		if dice_data["type"] == DiceType.REROLL && up_face >0:
			if is_on_dice:
				overlap_dice.roll()
				roll()
#		else:
#			print("not reroll dice or no rerolls")
		global_position = snap_area.global_position + offset
		snap_area.filler(self)
		is_grabbing = false
	else:
		go_to_last_snap()


func _on_dice_area_area_entered(area):
	if area.is_in_group("dice_area"):
		overlap_dice = area.get_parent()
		is_on_dice = true


func _on_dice_area_area_exited(area):
	if area.is_in_group("dice_area"):
		overlap_dice = null
		is_on_dice = false
