extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Area2D/CollisionShape2D.shape = RectangleShape2D.new()
	#$Area2D/CollisionShape2D.shape.set_size(Vector2(size.x, size.y))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	print("Entered: ", body)
	Events.end_zone_hit.emit(self, body)
