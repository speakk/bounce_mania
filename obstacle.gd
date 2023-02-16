extends StaticBody2D

const CIRCLE = preload("res://circle.tscn")

func create_light_occluder(polygon, new_position, new_rotation, new_scale):
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
	drawPolygon.polygon = polygon.duplicate()
	drawPolygon.position = new_position
	drawPolygon.rotation = new_rotation
	drawPolygon.scale = new_scale
	add_child(drawPolygon)

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		if child is CollisionPolygon2D:
			var drawPolygon = create_draw_polygon(child.polygon, child.position, child.rotation, child.scale)
			add_child(drawPolygon)
			
			var lightOccluder = create_light_occluder(child.polygon, child.position, child.rotation, child.scale)
			add_child(lightOccluder)
			
		elif child is CollisionShape2D and child.shape is CircleShape2D:
			var circle = CIRCLE.instantiate()
			var position = child.position
			circle.size = child.shape.radius
			circle.scale = child.scale
			add_child(circle)
			
			var lightOccluder = create_light_occluder(circle._polygon, child.position, child.rotation, child.scale)
			add_child(lightOccluder)
		
		elif child is Path2D:
			var polygon = child.curve.get_baked_points()
			child.curve.bake_interval = 50
			var drawPolygon = create_draw_polygon(polygon, child.position, child.rotation, child.scale)
			
			var collisionPolygon = CollisionPolygon2D.new()
			collisionPolygon.polygon = polygon.duplicate()
			
			add_child(drawPolygon)
			add_child(collisionPolygon)
			
			#add_child()
			
	
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)
	
func _on_palette_changed(new_palette, _a, _b):
	var children = get_children()
	for child in children:
		if child is Polygon2D or child is Circle:
			child.color = new_palette.background_b * 1.5
			child.color.h = wrapf(child.color.h - 0.1, 0, 1)
