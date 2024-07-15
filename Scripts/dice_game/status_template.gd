extends TextureRect

var game_manager = GameManager
var status_data
@onready var text_label = $Label
@onready var from_parent = get_node("../..").master
func setup_status(input_data:Dictionary):
	status_data = input_data
	texture = load(status_data["texture"])
	if status_data["name"] != "reflect":
		text_label.text = var_to_str(from_parent.status_conditions.count(status_data["status_condition"]))
	else:
		text_label.text = var_to_str(game_manager.player_resource.reflect)

func update_status():
	if status_data["name"] != "reflect":
		var status_count = from_parent.status_conditions.count(status_data["status_condition"])
		if status_count >0:
			text_label.text = var_to_str(status_count)
		else:
			from_parent.spawned_statuses.remove_at(from_parent.spawned_statuses.find(status_data["status_condition"]))
			queue_free()
	else:
		if game_manager.player_resource.reflect <=0:
			queue_free()
		else:
			text_label.text = var_to_str(game_manager.player_resource.reflect)
