extends Area2D
@onready var discard_button = $"../discard_button"
@onready var dictated_button = $"../dictated_button"
@onready var dice_game = $"../../.."
@export var is_filled:bool = false

var filled_node

func _process(delta):
	if monitoring:
		if get_overlapping_areas().size() < 1:
			filled_node = null
			is_filled = false
		if get_overlapping_areas().size() > 0:
			is_filled = true
			var overlapping_areas = get_overlapping_areas()
			filled_node = overlapping_areas[0].get_parent()



func filler(node:Node):
	filled_node = node

func start_fate_fragment(discarding:bool):
	if filled_node != null:
		discard_button.visible = discarding
		
		
func start_dictated_fate(changing:bool):
	if filled_node != null:
		dictated_button.visible = changing
		
		
func _on_label_button_down():#ONLY WORKS FOR FATE FRAGMENT DICE RN
	var dice_game = $"../../.."
	#DISCARD DICE
	dice_game.discard_dice(filled_node)
	dice_game.start_fate_fragment(false)
	is_filled = false
	dice_game.call_deferred("set_player_hand")
	var pick_die = dice_game.current_dice_deck.pick_random()
#	#add dice to hand
	dice_game.call_deferred("add_dice_to_hand",pick_die)
#	#remove dice from inventory
	dice_game.current_dice_deck.remove_at(dice_game.current_dice_deck.find(pick_die))
	dice_game.cancel_item_button.release_limbo_item()
		


func _on_dictated_button_button_down():
	var dice_game = $"../../.."
	#Change dice Face to max value
	filled_node.set_face_to_highest()
	
	#close fate choice
	dice_game.start_dictated_fate(false)
	dice_game.cancel_item_button.release_limbo_item()
