extends TextureButton
class_name POI

var poi_data
@onready var mouse_detector = $Area2D
var normal_texture = load("res://Sprites/map_assets/circle_poi.png")
var hover_texture = load("res://Sprites/map_assets/circle_poi_hover.png")
var click_texture = load("res://Sprites/map_assets/circle_poi_click.png")

#var is_pressed:bool = false

func _ready():
	mouse_detector.mouse_entered.connect(poi_hover)
	mouse_detector.mouse_exited.connect(poi_reset)
	mouse_detector.input_event.connect(poi_click)
	


# Called when the node enters the scene tree for the first time.
func setup_poi(input_data:Dictionary):
	poi_data = input_data
	


func poi_reset():
	texture_normal = normal_texture
	
func poi_hover():
	texture_normal = hover_texture
	
func poi_click(_viewport,event,_shapeID):
	if event is InputEventMouseButton:
		if event.pressed:
			#print_poi_data()
			send_poi_data_to_player()
			texture_normal = click_texture
#		elif !event.pressed:
#			is_pressed = false
#			poi_hover()
		else:
			poi_hover()

func print_poi_data():
	print("poi data is: ", poi_data)
	
func send_poi_data_to_player():
	$"../../../../../player".try_poi(self)
	
	
	
	
	
