extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		if typeof(child) == typeof(CollisionPolygon2D):
			var drawPolygon = Polygon2D.new()
			drawPolygon.polygon = child.polygon
			drawPolygon.position = child.position
			drawPolygon.color = Colors.background_b * 1.5
			drawPolygon.color.h = wrapf(drawPolygon.color.h - 0.1, 0, 1)
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
