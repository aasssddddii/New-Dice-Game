extends ColorRect

var game_manager = GameManager


@onready var ui_name = $VBoxContainer/ui_name
@onready var ui_description = $VBoxContainer/ui_description
#@onready 

var description_data:Dictionary = {
#	"long_name":"",
#	"description":"",
#	"faces":[]
}
func relocate(location_node:Node2D):
	global_position = location_node.global_position
	

func setup_description(input_data:Dictionary):
	var ui_faces_parent = $VBoxContainer/ui_faces
	var ui_faces_label = $VBoxContainer/dice_face_label
	
	description_data = input_data
	
	ui_name.text = description_data["long_name"]
	ui_description.text = description_data["description"]
	if description_data["item_code"] == 0:
		ui_faces_parent.visible = true
		ui_faces_label.visible = true
		var face_index:int = 0
		var dice_ref = game_manager.dice_lib.get_dice_data(description_data["item_name"])
		for face_value in description_data["faces"]:
			match face_value:
				0:
					ui_faces_parent.get_child(face_index).texture = load(dice_ref["none_texture"])
				1:
					ui_faces_parent.get_child(face_index).texture = load(dice_ref["texture"])
			
			face_index += 1
	else:
		ui_faces_label.visible = false
		ui_faces_parent.visible = false
	
	
	
	
	
	visible = true
	
func close_description():
	visible = false
