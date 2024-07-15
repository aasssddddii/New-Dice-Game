extends TextureRect


var status_data
@onready var text_label = $Label
@onready var from_parent = get_node("../..")
func setup_status(input_data:Dictionary):
	status_data = input_data
	texture = load(status_data["texture"])
	text_label.text = var_to_str(from_parent.status_conditions.count(status_data["status_condition"]))

func update_status():
	var status_count = from_parent.status_conditions.count(status_data["status_condition"])
	if status_count >0:
		text_label.text = var_to_str(status_count)
	else:
		from_parent.spawned_statuses.remove_at(from_parent.spawned_statuses.find(status_data["status_condition"]))
		queue_free()
