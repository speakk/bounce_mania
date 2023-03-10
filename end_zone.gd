@tool
extends Node2D

var area
var shape

# Called when the node enters the scene tree for the first time.
func _ready():
	area = Area2D.new()
	area.set_collision_mask_value(1, false)
	area.set_collision_mask_value(2, false)
	area.set_collision_mask_value(3, true)
	
	shape = CollisionShape2D.new()
	shape.shape = RectangleShape2D.new()

	area.body_entered.connect(_on_area_2d_body_entered)
	area.add_child(shape)
	add_child(area)

	$EndZoneRect.set_light_mask(5)
	$EndZoneRect.item_rect_changed.connect(_item_rect_changed)

	if not Engine.is_editor_hint():
		Events.palette_changed.connect(_on_palette_changed)
		_on_palette_changed(Colors.get_current_palette(), null, null)
	
		Events.level_finished.connect(_on_level_finished)
	
	_item_rect_changed()

func _item_rect_changed():
	$PointLight2D.global_position = $EndZoneRect.global_position + Vector2($EndZoneRect.size.x /2, $EndZoneRect.size.y / 2)
	$PointLight2D.scale = Vector2(0.4, 0.4) + ($EndZoneRect.size / 100) * 0.6
	
	$GPUParticles2D.position = $EndZoneRect.position + Vector2($EndZoneRect.size.x /2, $EndZoneRect.size.y / 2)
		
	$Control.size = $EndZoneRect.size
	$Control.global_position = $EndZoneRect.global_position
	
	# Shape origin is in the center of the shape, so do this to ensure we move it to corner origin
	area.global_position = $EndZoneRect.global_position + Vector2($EndZoneRect.size.x /2, $EndZoneRect.size.y / 2)
	shape.position = Vector2(0, 0)
	shape.shape.set_size(Vector2($EndZoneRect.size.x, $EndZoneRect.size.y))
	print("RECT CHANGED")
	
	
func _on_palette_changed(new_palette, _a, _b):
	$EndZoneRect.color = new_palette.accent_b
	$PointLight2D.color = Colors.accent_b
	$EndZoneRect.color.v = minf($EndZoneRect.color.v, 0.4)

func _on_area_2d_body_entered(body):
	Events.end_zone_hit.emit(self, body)

func _on_level_finished(_a, _b):
	$GPUParticles2D.emitting = true
