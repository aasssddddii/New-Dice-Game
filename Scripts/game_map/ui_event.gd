extends Node2D

var game_manager = GameManager


var button_prefab = preload("res://Prefabs/event/button.tscn")

var event_data:Dictionary

func _ready():
	setup_event(game_manager.event_lib.test_event_data)

# Called when the node enters the scene tree for the first time.
func setup_event(input_data:Dictionary):
	var ui_title = $Title
	var ui_body = $ui_body
	var choice_parent = $options_parent
	
	event_data = input_data
	
	ui_title.text = event_data["title"]
	ui_body.text = event_data["body"]
	var option_text_array = event_data["option_text"]
	var option_index:int = 0
	for option in event_data["options"]:
		var next_option = button_prefab.instantiate()
		var keys_array = option.keys()
		var values_array = option.values()
		next_option.text = keys_array[0]
		
		next_option.button_down.connect(event_resolver.bind(values_array[0],option_text_array[option_index]))
		choice_parent.add_child(next_option)
		option_index += 1
	
	
func event_resolver(event_result:event_library.EventResults, result_text:String):
	
	print("test: ", event_result, " text: ", result_text)
	match event_result:
		event_library.EventResults.LOSSHPMINOR:
			pass
		event_library.EventResults.LOSSHPMAJOR:
			pass
		event_library.EventResults.STARTBATTLE:
			pass
		event_library.EventResults.ADDHPMINOR:
			pass
		event_library.EventResults.ADDHPMAJOR:
			pass
		event_library.EventResults.ADDDICE:
			pass
		event_library.EventResults.ADDITEM:
			pass
		event_library.EventResults.NOTHING:
			pass
		
		
	setup_result(result_text)
		
		
		
		
		
func setup_result(result_text:String):
	var result_bg = $result_background
	var ui_result_body = $result_background/VBoxContainer/ui_body
	ui_result_body.text = result_text
	result_bg.visible = true
	


func _on_button_button_down():
	$"../..".manage_camera("map_reset")
	queue_free()
