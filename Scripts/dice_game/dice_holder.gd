extends Area2D

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
	#		if name == "hand1":
	#			print(filled_node)


func filler(node:Node):
	filled_node = node

