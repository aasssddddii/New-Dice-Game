extends TextureButton

#var current_sprite
var item_data:Dictionary
var ui_item_description
# Called when the node enters the scene tree for the first time.
func setup_item(input_data:Dictionary):
	item_data = input_data
	texture_normal  = load(input_data["texture"])
	ui_item_description = get_node_or_null("../../ui_item_desciption")


func _on_mouse_entered():
	manage_description(item_data,true)


func _on_mouse_exited():
	manage_description(item_data,false)


func manage_description(input_data,make_visible:bool):
	ui_item_description.visible = make_visible
	if make_visible:
		if input_data["item_code"] == 0:
			ui_item_description.setup_description({
				"name":input_data["long_name"],
				"description":input_data["description"],
				"faces":input_data["faces"]
				})
		else:
			ui_item_description.setup_description({
				"name":input_data["long_name"],
				"description":input_data["description"],
				"faces":[]
				})
