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

#var shop_lib = preload("res://resources/shop_item_library.tres")

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
var blank_data: Dictionary
var one_data:Dictionary
var faces: Dictionary
var face_sprites: Dictionary = {
	"blank":null,
	"one":null,
	"two":null
}
var upgrade_level



func _physics_process(delta):
	if Input.is_action_just_released("mouse_click_up"):
		is_grabbing = false
	
	if snap_area:
		if !is_grabbing && global_position != snap_area.global_position:
			global_position = snap_area.global_position + offset
		


	if is_grabbing:
		global_position = get_global_mouse_position() + offset
func overlapping_dice(on_dice:bool, parent:Node):
	is_on_dice = on_dice
	if parent:
		var dice_node = parent
		if !is_grabbing && on_dice && !dice_node.is_grabbing:
			var up_face = dice_data["up_face"]
			if up_face["amount"] == 1:
				#reroll(self)
				print("dice.gd: should reroll")
				dice_node.reroll(dice_node)
				
			else:
				print("no rerolls")


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
	texture_normal = load(dice_data["texture"])



func _on_dice_area_area_entered(area):
	print(name, " dice now overlapping area ", area)
	if area.get_collision_layer() > 1 && dice_data["type"] == DiceType.REROLL:
		overlap_dice = area
		print("overlapping dice now ", overlap_dice)
		overlapping_dice(true,overlap_dice.get_parent())
	else:
		if area.is_in_group("dice_snap"):
			if !area.is_filled:
				if last_snap_area != snap_area:
					last_snap_area = snap_area
				snap_area = area
		


func _on_dice_area_area_exited(area):
	if area == overlap_dice:
		overlap_dice = null
	pass # Replace with function body.


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
		
		global_position = snap_area.global_position + offset
		
		if snap_area.name == "inventory" && is_grabbing:
			var discard_event = get_node_or_null("..")
			discard_event.import_dice_into_deck(dice_data["name"])
			discard_event.update_deck()
			queue_free()
		else:
			snap_area.filler(self)
			if overlap_dice != null && dice_data["type"] == DiceType.REROLL:
				overlapping_dice(true,overlap_dice.get_parent())
		is_grabbing = false
	else:
		go_to_last_snap()
