extends Node2D

var game_manager = GameManager

@onready var submit_button = $player_ui/submit
@onready var text_box = $TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	submit_button.visible = false
	pass # Replace with function body.


func _on_text_edit_text_changed():
	if text_box.text != "":
		submit_button.visible = true
	else:
		submit_button.visible = false


func _on_submit_button_down():
	var choice_creator = $"../choice_creator"
	var evaluvated_text = evaluate_text(text_box.text)
	if evaluvated_text != []:
		choice_creator.setup_wish(evaluvated_text,true)
		$"../choice_creator".poi_manager()
		queue_free()
		
		
		
func evaluate_text(input_text:String):
	submit_button.visible = false
	var valid_wishes:Array[int]#wish_code
	print("evaluating text [", input_text,"]")
	for valid_wish_type in game_manager.poi_lib.valid_wishes:
		for trigger in valid_wish_type["triggers"]:
			if input_text.to_lower().contains(trigger):
				print("text has triggered ",trigger," with wish code: ", valid_wish_type["wish_code"])
				valid_wishes.append(valid_wish_type["wish_code"])
				break
	return valid_wishes
	


func _on_close_button_down():
	$"../choice_creator".poi_manager()
	queue_free()
