extends Node2D
class_name Description_Holder

var game_manager = GameManager

@export var ui_item_description:ColorRect


func is_item_usable(item_data:Dictionary):
	match item_data["item_code"]:
		0:
			return false
		2:
			match item_data["use_type"]:
				0:
					return true
				1:
					return false
				2:
					return true
			
