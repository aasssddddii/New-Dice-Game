extends "res://Scripts/dice_game/dice_holder.gd"


signal action_slot_filled()
signal action_slot_unfilled()

var has_emitted:bool = false
var unfilled:bool = false



func _process(delta):
	if get_overlapping_areas().size() < 1:
		is_filled = false
		has_emitted = false
		is_unfilled_emission()
		filled_node = null
	if get_overlapping_areas().size() > 0:
		is_filled = true
		unfilled = false
		
		var overlapping_areas = get_overlapping_areas()
		filled_node = overlapping_areas[0].get_parent()
		if !filled_node.is_grabbing && is_filled:
			is_filled_emission()
			
			
			
			
			
func is_filled_emission():
	if !has_emitted:
		#print(name," is now filled: ", filled_node)
		action_slot_filled.emit()
		has_emitted = true
		
func is_unfilled_emission():
	if !unfilled:
		#print(name," is now unfilled: ", filled_node)
		action_slot_unfilled.emit()
		unfilled = true
