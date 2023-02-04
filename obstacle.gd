extends StaticBody2D

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
	
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)
	
func _on_palette_changed(new_palette, _a, _b):
	var children = get_children()
	for child in children:
		if child is Polygon2D:
			child.color = new_palette.background_b * 1.5
			child.color.h = wrapf(child.color.h - 0.1, 0, 1)
