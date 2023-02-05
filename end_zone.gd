extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var area = Area2D.new()
	area.set_collision_mask_value(1, false)
	area.set_collision_mask_value(2, false)
	area.set_collision_mask_value(3, true)
	
	var shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()
	shape.shape.set_size(Vector2($EndZoneRect.size.x, $EndZoneRect.size.y))
	# Shape origin is in the center of the shape, so do this to ensure we move it to corner origin
	area.position = $EndZoneRect.position + Vector2($EndZoneRect.size.x /2, $EndZoneRect.size.y / 2)
	area.add_child(shape)
	
	area.body_entered.connect(_on_area_2d_body_entered)
	add_child(area)
	
	$Control.size = $EndZoneRect.size
	$Control.global_position = $EndZoneRect.global_position
	
	$EndZoneRect.set_light_mask(5)
	
	$PointLight2D.position += $EndZoneRect.position + Vector2($EndZoneRect.size.x /2, $EndZoneRect.size.y / 2)
	$PointLight2D.scale = Vector2(0.4, 0.4) + ($EndZoneRect.size / 100) * 0.6
	
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)
	
func _on_palette_changed(new_palette, _a, _b):
	$EndZoneRect.color = new_palette.accent_b
	$PointLight2D.color = Colors.accent_b
	$EndZoneRect.color.v = minf($EndZoneRect.color.v, 0.4)

func _on_area_2d_body_entered(body):
	Events.end_zone_hit.emit(self, body)
