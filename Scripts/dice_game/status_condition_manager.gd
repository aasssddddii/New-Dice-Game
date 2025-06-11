extends GridContainer

var game_manager = GameManager
var spawned_statuses:Array[Status_Library.StatusCondition]

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().name == "enemy_template":
		$"..".status_changed.connect(reshow_status)
	else:
		$"../../..".status_changed.connect(reshow_status)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func reshow_status(status_conditions:Array[Status_Library.StatusCondition]):
	print("statuses to draw: ", status_conditions)
	#clear last draw
	spawned_statuses.clear()
	for child in get_children():
		child.queue_free()
	
	for value in status_conditions:
		var status_ref = game_manager.status_lib.get_status_data(value)
		if spawned_statuses.find(value) == -1:
			spawned_statuses.append(value)
			var next_ui_status = game_manager.status_lib.status_prefab.instantiate()
			add_child(next_ui_status)
			next_ui_status.setup_status(status_ref)

