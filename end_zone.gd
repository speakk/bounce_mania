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
	area.position = $EndZoneRect.position
	area.add_child(shape)
	
	area.body_entered.connect(_on_area_2d_body_entered)
	add_child(area)
	
	$Control.size = $EndZoneRect.size
	$Control.position = $EndZoneRect.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	Events.end_zone_hit.emit(self, body)
