extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var left = WorldBoundaryShape2D.new()
	left.normal = Vector2.RIGHT
	
	var right = WorldBoundaryShape2D.new()
	right.normal = Vector2.LEFT
	
	var top = WorldBoundaryShape2D.new()
	top.normal = Vector2.DOWN
	
	var bottom = WorldBoundaryShape2D.new()
	bottom.normal = Vector2.UP
	
	_add_body(left, $ColorRect.position)
	_add_body(right, Vector2($ColorRect.position.x + $ColorRect.size.x, $ColorRect.position.y))
	_add_body(top, $ColorRect.position)
	_add_body(bottom, Vector2($ColorRect.position.x, $ColorRect.position.y + $ColorRect.size.y))
	
	$ColorRect.z_index = -3
	
	$Background.show()
	%Background.position = $ColorRect.position + Vector2($ColorRect.size.x / 2, $ColorRect.size.y / 2)
	#%Background.position = $ColorRect.position
	%Background.scale = $ColorRect.scale
	%Background.texture.width = $ColorRect.size.x
	%Background.texture.height = $ColorRect.size.y
	
	var outside_padding = 600
	$OutsideBackground.texture = ResourceCache.OUTSIDE_BACKGROUND
	#$OutsideBackground.texture.width = $ColorRect.size.x + outside_padding
	#$OutsideBackground.texture.height = $ColorRect.size.y + outside_padding
	$OutsideBackground.position = $ColorRect.position - Vector2($OutsideBackground.texture.width, $OutsideBackground.texture.height) / 2
	
#
#	print("SIZE", $Background.texture.width, " vs ", $Background.texture.height)
#
	#for i in range($Background)
	
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)
	
	Events.level_loaded.connect(_level_loaded)

func _level_loaded(level_id):
	var index = Levels.get_level_index(level_id)
	var background_no = fmod(index, ResourceCache.BACKGROUNDS.size())
	%Background.material.set_shader_parameter("extra_texture", ResourceCache.BACKGROUNDS[background_no])

func _process(delta):
	%Background.material.set_shader_parameter("offset2", get_viewport().get_camera_2d().get_screen_center_position() / get_viewport().get_visible_rect().size)
	pass

func _on_palette_changed(new_palette, _a, _b):
	#%Background.material.set_shader_parameter("mod_color", new_palette.accent_b)
	#%Background.material.set_shader_parameter("mod_color2", new_palette.accent_b)

	#$ColorRect.color = new_palette.background_b
	$ColorRect.color = Color.TRANSPARENT
	#$Background.modulate = new_palette.background_a

func _add_body(boundary_shape, body_position):
	var physics = StaticBody2D.new()
	var shape = CollisionShape2D.new()
	physics.global_position = body_position
	physics.physics_material_override = PhysicsMaterial.new()
	physics.physics_material_override.bounce = 0.5
	shape.shape = boundary_shape
	physics.add_child(shape)
	add_child(physics)
