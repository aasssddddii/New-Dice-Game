extends TextureButton

var current_enemy_resource:Resource





func setup_enemy(resource:Resource):
	current_enemy_resource = resource
	name = current_enemy_resource.enemy_name
	texture_normal = current_enemy_resource.main_texture
	global_position -= Vector2(64,64)
	#print("enemy now:", current_enemy_resource.enemy_name)
