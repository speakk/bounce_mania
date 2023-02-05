extends StaticBody2D

const CIRCLE = preload("res://circle.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		if child is CollisionPolygon2D:
			var drawPolygon = Polygon2D.new()
			drawPolygon.polygon = child.polygon
			drawPolygon.position = child.position
			
			drawPolygon.rotation = child.rotation
			drawPolygon.scale = child.scale
			add_child(drawPolygon)

			var lightOccluder = LightOccluder2D.new()
			var occluder = OccluderPolygon2D.new()
			occluder.polygon = child.polygon.duplicate()
			
			lightOccluder.occluder = occluder
			lightOccluder.position = child.position
			lightOccluder.rotation = child.rotation
			lightOccluder.scale = child.scale
			add_child(lightOccluder)
		elif child is CollisionShape2D and child.shape is CircleShape2D:
			var circle = CIRCLE.instantiate()
			var position = child.position
			circle.size = child.shape.radius
			circle.scale = child.scale
			add_child(circle)
			
			var lightOccluder = LightOccluder2D.new()
			var occluder = OccluderPolygon2D.new()
			occluder.polygon = circle._polygon.duplicate()
			
			lightOccluder.occluder = occluder
			lightOccluder.position = child.position
			lightOccluder.rotation = child.rotation
			lightOccluder.scale = child.scale
			add_child(lightOccluder)
	
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)
	
func _on_palette_changed(new_palette, _a, _b):
	var children = get_children()
	for child in children:
		if child is Polygon2D or child is Circle:
			child.color = new_palette.background_b * 1.5
			child.color.h = wrapf(child.color.h - 0.1, 0, 1)
