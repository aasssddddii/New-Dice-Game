extends TextureButton
class_name Dice

var offset =  Vector2(-28,-28)
var game_manager = GameManager
enum DiceType {
	ATTACK,#0
	DEFEND,#1
	REROLL,#2
	BLEED,#3
	HEAL,#4
	GOLD,#5
	REFLECT,#6
	LIFESTEAL,#7
	POISON,#8
	CURE,#9
	DISARM,#10
	STUN,#11
	ATKBUFF,#12
	DEFBUFF,#13
	ATKDEBUFF,#14
	DEFDEBUFF,#15
	FIRE,#16
	ICE,#17
	LIGHTNING,#18
	NONE#19
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
var upgrade_level:int = 0

var ui_item_description

func _ready():
	area.area_entered.connect(func set_snap_area(entered_area:Area2D):
		#print("dice has entered area: ", entered_area.name)
		if entered_area.is_in_group("dice_snap"):
			if !entered_area.is_filled:
				if last_snap_area != snap_area:
					last_snap_area = snap_area
				snap_area = entered_area
		)
	if $"../..".name == "rolloff_event":
		offset =  Vector2(-52,-52)


func _physics_process(delta):
	if Input.is_action_just_released("mouse_click_up"):
		is_grabbing = false
	if snap_area:
		if snap_area.name == "inventory" && !is_grabbing:
			$"../../player_inventory/PanelContainer/GridContainer".add_item_to_grid(dice_data)
			queue_free()
		elif snap_area.is_in_group("required_dice") && !is_grabbing:
			if !snap_area.get_parent().is_correct_filled_dice:#makes no sense but work as of now
				$"../../player_inventory/PanelContainer/GridContainer".add_item_to_grid(dice_data)
				queue_free()
			else:
				global_position = snap_area.global_position + offset
			#decide if dice should stay
		elif !is_grabbing && global_position != snap_area.global_position:
			global_position = snap_area.global_position + offset
		
	if is_grabbing:
		global_position = get_global_mouse_position() + offset
		
		

func send_dice_to_inventory():
	$"../../player_inventory/PanelContainer/GridContainer".add_item_to_grid(dice_data)
	queue_free()
	
func get_current_snap_area():
	if snap_area:
		return true
	else:
		return false

func go_to_last_snap():
	#print("test")
	if snap_area:
		#print("snap_area: ", snap_area.name)
		if snap_area.name != "inventory":
			global_position = snap_area.global_position + offset
		else:
			get_parent().add_item_to_grid(dice_data)
			queue_free()
	else:
		#print("last_snap_area: ", last_snap_area.name)
		if last_snap_area.name != "inventory":
			global_position = last_snap_area.global_position + offset
		else:
			get_parent().add_item_to_grid(dice_data)
			queue_free()


func set_dice_data(data:Dictionary):
	dice_data = data
	name = dice_data["item_name"]
	roll()
	
	
func setup_event_data(data:Dictionary):
	dice_data = data
	name = dice_data["item_name"]
	texture_normal = load(dice_data["texture"])
	#print("trying to set snap area: ", get_current_snap_area())
	is_grabbing = true

func roll():
	#print("rolling dice: ", name)
	
	#change up face generration to be based on upgrade level
	up_face = game_manager.dice_lib.upgrade_tier[dice_data["upgrade_level"]].pick_random()
	match up_face:
		0:
			texture_normal = load(dice_data["none_texture"])
		1:
			texture_normal = load(dice_data["texture"])
		2:
			texture_normal = load(dice_data["two_texture"])
		3:
			texture_normal = load(dice_data["three_texture"])
		4:
			texture_normal = load(dice_data["four_texture"])
		_:
			print("not implemented in faces: dice.gd")
	
	

func set_face_to_highest():
	up_face = game_manager.dice_lib.upgrade_tier[dice_data["upgrade_level"]].back()
	match up_face:
		0:
			texture_normal = load(dice_data["none_texture"])
		1:
			texture_normal = load(dice_data["texture"])
		2:
			texture_normal = load(dice_data["two_texture"])
		3:
			texture_normal = load(dice_data["three_texture"])
		4:
			texture_normal = load(dice_data["four_texture"])
		_:
			print("not implemented in faces: dice.gd")


func _on_button_down():
	ui_item_description.close_description()
	if get_current_snap_area():
		snap_area.filler(self)
	if player_bar_node != null:
		if !player_bar_node.enemy_taking_turn:
			is_grabbing = true 
	else:
		is_grabbing = true
		
	if $"../..".name == "Dice_Battle":
		var dice_battle = $"../.."
		dice_battle.close_item_selections()
		dice_battle.cancel_item_button.give_player_limbo_item()


func _on_button_up():
	#print("test")
	if get_current_snap_area():
		if dice_data["type"] == DiceType.REROLL && up_face >0:
			if is_on_dice:
				overlap_dice.roll()
				roll()
			#sets dice snap area for staying on screen VVV
		global_position = snap_area.global_position + offset
		snap_area.filler(self)
		is_grabbing = false
			#print("snap_area name: ", snap_area.name)
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


func _on_mouse_entered():
	if !is_grabbing:
		ui_item_description.setup_description(dice_data)



func _on_mouse_exited():
	if !is_grabbing:
		ui_item_description.close_description()

