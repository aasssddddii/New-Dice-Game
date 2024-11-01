extends TextureRect


@export var item_data:Dictionary = {
	"item_code":0,
	"item_name":"item_name",
	"texture":"image_path",
	"none_texture":"image_path",
	"price":0,
	"upgrade_price":0,
	"animation_target":"target",
	"type":Dice.DiceType.NONE,
	"effect":false,
	"element":Dice.DamageElement.NONE,
	"faces":[0,0,0,1,1,1],
	"long_name":"long_name",
	"description":"description"
	}
@export var description_holder:Description_Holder
@export var description_location:Node2D


func _ready():
	mouse_entered.connect(open_description)
	mouse_exited.connect(close_description)
	
	
func open_description():
	description_holder.ui_item_description.relocate(description_location)
	description_holder.ui_item_description.setup_description(item_data)
	
	
func close_description():
	description_holder.ui_item_description.close_description()
	
