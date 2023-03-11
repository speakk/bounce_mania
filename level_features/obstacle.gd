extends StaticBody2D

class_name Obstacle

@export var rotate_in_place := false
@export var rotation_speed := 0.0
@export var movement_vector := Vector2(0, 0)
@export var movement_speed := 0.0
@export var is_deadly := false
@export var sticky := false

var original_position

const CIRCLE = preload("res://circle.tscn")

func create_light_occluder(polygon, new_position, new_rotation, new_scale) -> LightOccluder2D:
	var lightOccluder = LightOccluder2D.new()
	var occluder = OccluderPolygon2D.new()
	occluder.polygon = polygon.duplicate()
	
	lightOccluder.occluder = occluder
	lightOccluder.position = new_position
	lightOccluder.rotation = new_rotation
	lightOccluder.scale = new_scale
	
	return lightOccluder
	
func create_draw_polygon(polygon, new_position, new_rotation, new_scale):
	var drawPolygon = Polygon2D.new()
	drawPolygon.name = "Polygon2D"
	drawPolygon.polygon = polygon.duplicate()
	drawPolygon.position = new_position
	drawPolygon.rotation = new_rotation
	drawPolygon.scale = new_scale
	drawPolygon.light_mask = 2
	#drawPolygon.material = ShaderMaterial.new()
	#drawPolygon.material.shader = POLYGON_SHADER
	#drawPolygon.material.set_shader_parameter("blur_amount", 5)
	add_child(drawPolygon)
	
	var borderLine = Line2D.new()
	borderLine.width = 1
	borderLine.antialiased = false
	borderLine.points = polygon.duplicate()
	borderLine.position = new_position
	borderLine.rotation = new_rotation
	borderLine.scale = new_scale
	borderLine.light_mask = 2
	#add_child(borderLine)

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.level_timer_changed.connect(_level_timer_changed)
	#self.physics_material_override = physics_material_override.duplicate(true)
	physics_material_override = PhysicsMaterial.new()

	if sticky:
		#physics_material_override.absorbent = true
		physics_material_override.absorbent = true
		physics_material_override.bounce = 1
	else:
		physics_material_override.absorbent = false
		physics_material_override.bounce = 0.5
		
	

	var children = get_children()
	original_position = position
	for child in children:
		if child is CollisionPolygon2D:
			var drawPolygon = create_draw_polygon(child.polygon, child.position, child.rotation, child.scale)
			add_child(drawPolygon)
			
			var lightOccluder := create_light_occluder(child.polygon, child.position, child.rotation, child.scale)
			if not is_deadly:
				add_child(lightOccluder)
			
		elif child is CollisionShape2D and child.shape is CircleShape2D:
			var circle = CIRCLE.instantiate()
			circle.position = child.position
			circle.size = child.shape.radius
			circle.scale = child.scale
			add_child(circle)
			
			var lightOccluder = create_light_occluder(circle._polygon, child.position, child.rotation, child.scale)
			add_child(lightOccluder)
		
		elif child is CollisionShape2D and child.shape is RectangleShape2D:
			var drawRectangle = ColorRect.new()
			drawRectangle.position = child.position - child.shape.size/2
			drawRectangle.custom_minimum_size = child.shape.size
			add_child(drawRectangle)
			
			var new_size = child.shape.size
			var polygon = PackedVector2Array([
				Vector2(0, 0),
				Vector2(new_size.x, 0),
				Vector2(new_size.x, new_size.y),
				Vector2(0, new_size.y),
			])
			var lightOccluder = create_light_occluder(polygon, drawRectangle.position, child.rotation, child.scale)
			add_child(lightOccluder)
		
		
		elif child is Path2D:
			child.curve.bake_interval = 200
			var polygon = child.curve.get_baked_points()
			var drawPolygon = create_draw_polygon(polygon, child.position, child.rotation, child.scale)
			
			var collisionPolygon = CollisionPolygon2D.new()
			collisionPolygon.polygon = polygon.duplicate()
			collisionPolygon.position = child.position
			collisionPolygon.scale = child.scale
			
			#physics_material_override = PhysicsMaterial.new()
			#physics_material_override.absorbent = true
			#physics_material_override.friction = 0
			#physics_material_override.bounce = 1
			
			add_child(drawPolygon)
			add_child(collisionPolygon)
			
			#add_child()
	
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)
		
	if is_deadly:
		add_to_group("traps")
		#$DeadlyLight.show()
		

func _level_timer_changed(level_time):
	if rotate_in_place:
		rotation = level_time * rotation_speed
	
	if movement_vector.length_squared() > 0:
		position = original_position + movement_vector * sin(level_time * movement_speed)

func _on_palette_changed(new_palette, _a, _b):
	var children = get_children()
	for child in children:
		if child is Polygon2D or child is Circle or child is ColorRect:
			child.color = new_palette.background_b * 1.5
			child.color.h = wrapf(child.color.h - 0.1, 0, 1)
			
			if sticky:
				child.color.v *= 0.9
				child.color.s *= 0.9
				child.color.h += 0.4
			
			if is_deadly:
				child.color = Color.FIREBRICK
		
		if child is Line2D:
			child.default_color = Color(1,1,1,0.3)
		
