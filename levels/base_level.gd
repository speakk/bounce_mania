extends Node2D

var OBSTACLE_SHADER = preload("res://level_features/obstacle.gdshader")
var canvas_group


func _on_palette_changed(new_palette, _a, _b):
	canvas_group.material.set_shader_parameter("border_color", new_palette.accent_b)

func _ready():
	get_node("PlayerMarker").visible = false
	$TextureRect.modulate = Colors.background_a
	
	canvas_group = CanvasGroup.new()
	canvas_group.material = ShaderMaterial.new()
	canvas_group.use_mipmaps = true
	canvas_group.clear_margin = 60
	canvas_group.fit_margin = 60
	canvas_group.material.shader = OBSTACLE_SHADER
	canvas_group.material.set_shader_parameter("mod_color", Color.BLACK)
	canvas_group.material.set_shader_parameter("blur_amount", 2)
	canvas_group.material.set_shader_parameter("border_width", 0.9)

	var deadly_canvas_group = CanvasGroup.new()
	deadly_canvas_group.material = ShaderMaterial.new()
	deadly_canvas_group.use_mipmaps = true
	deadly_canvas_group.material.shader = OBSTACLE_SHADER
	deadly_canvas_group.clear_margin = 60
	deadly_canvas_group.fit_margin = 60
	deadly_canvas_group.material.set_shader_parameter("blur_amount", 3)	
	deadly_canvas_group.material.set_shader_parameter("mod_color", Color.RED)	
	deadly_canvas_group.material.set_shader_parameter("border_width", 0.0)	
	
	for child in get_children():
		if child is Obstacle:
			remove_child(child)
			if child.is_deadly:
				deadly_canvas_group.add_child(child)
			else:
				canvas_group.add_child(child)
	
	add_child(canvas_group)
	add_child(deadly_canvas_group)
	
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)

func get_player_start_position():
	return get_node("PlayerMarker").position
