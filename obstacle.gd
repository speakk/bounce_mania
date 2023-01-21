extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		if typeof(child) == typeof(CollisionPolygon2D):
			var drawPolygon = Polygon2D.new()
			drawPolygon.polygon = child.polygon
			drawPolygon.position = child.position
			add_child(drawPolygon)
