extends Resource
class_name event_library

enum EventResults {
	LOSSHPMINOR,
	LOSSHPMAJOR,
	STARTBATTLE,
	ADDHPMINOR,
	ADDHPMAJOR,
	ADDDICE,
	ADDITEM,
	NOTHING
}


var dice_altar = preload("res://Prefabs/game_map/dice_altar.tscn")
var basic_event = preload("res://Prefabs/event/ui_event.tscn")

#LLO Three Test Events
var test_event_data = {
	"title":"Bofa",
	"body":"Deez big black balls",
	"options":[{"yes":EventResults.ADDHPMAJOR}, {"no":EventResults.LOSSHPMAJOR}],
	"option_text":["Bofa Deez Big Black Balls Have given you grace (ADD HP MAJOR)", "Bofa Deez Nutz Slappin you in the Jaw (Loss HP Major)"]
}

