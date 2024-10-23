extends GridContainer

var game_manager = GameManager
var inventory_data:Array[Dictionary] = []
@export var trade_side:String



func setup_inventory(input_data:Array[Dictionary],setup_side:String):
	inventory_data = input_data
	trade_side = setup_side
	generate_grid()


func generate_grid():
	clear_grid()
	var only_one_array = only_one_of_each(inventory_data)
	#print("input data, ", input_data)
	for item in only_one_array:
		#print("item: ", item)
		var next_item = game_manager.item_prefab.instantiate()
		add_child(next_item)
		next_item.setup_item(item,trade_side,0)
func clear_grid():
	for child in get_children():
		child.queue_free()
		
func update_grid():
	for child in get_children():
		child.update_quantity()

func add_item_to_grid(input_data:Dictionary):
	if inventory_data.find(input_data) != -1:
		print("Shop sanity FOUND in moving inventory")
		manage_grid(false,input_data)
	else:
		print("Shop sanity did NOT find in moving inventory")
		manage_grid(true,input_data)

	#manage_inventory("add",input_data)

func manage_grid(is_new:bool,item_data:Dictionary):
	manage_inventory("add",item_data)
	if !is_new:
		var item_found:bool = false
		for item in get_children():
			if !item_found:
				if item.item_data == item_data:#check item
					item_found = true
					#inventory_data.append(item_data).
					item.update_quantity()
			else:
				break
	else:
		var next_item:Shop_Item = game_manager.item_prefab.instantiate()
		add_child(next_item)
		#inventory_data.append(item_data)
		next_item.setup_item(item_data,trade_side,1)
		#inventory_data.append(next_item.item_data)
		
	

func get_inventory():
	return inventory_data
	
func manage_inventory(choice:String,input_data):
	match choice:
		"add":
			if typeof(input_data) == TYPE_DICTIONARY:
				inventory_data.append(input_data)
			else:
				print("error on item data")
		"remove":
			print("inventory BEFORE Sanity: ", inventory_data)
			if inventory_data.find(input_data) != -1:
				inventory_data.remove_at(inventory_data.find(input_data))
				print("inventory AFTER Sanity: ", inventory_data)
			else:
				print("error on item data cannot find in inventory")
				
	#generate_grid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func only_one_of_each(input_array:Array[Dictionary]):
	var output_array:Array[Dictionary] 
	
	for value in input_array:
		if !output_array.any(func(input):return input == value):
			output_array.append(value)
	
	return output_array
