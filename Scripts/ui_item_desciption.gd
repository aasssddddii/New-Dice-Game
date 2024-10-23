extends ColorRect

@onready var ui_name = $VBoxContainer/ui_name
@onready var ui_description = $VBoxContainer/ui_description
@onready var ui_faces_parent = $ui_faces

var description_data:Dictionary = {
#	"name":"",
#	"description":"",
#	"faces":[]
}
# Called when the node enters the scene tree for the first time.
func setup_description(input_data:Dictionary):
#	var ui_name = $ui_item_desciption/VBoxContainer/ui_name
#	var ui_description = $ui_item_desciption/VBoxContainer/ui_description
#	var ui_faces_parent = $ui_item_desciption/ui_faces
	
	description_data = input_data
	
	ui_name.text = description_data["name"]
	ui_description.text = description_data["description"]
