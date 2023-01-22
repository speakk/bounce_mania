extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var left = WorldBoundaryShape2D.new()
	left.normal = Vector2.RIGHT
	
	var right = WorldBoundaryShape2D.new()
	right.normal = Vector2.LEFT
	
	var top = WorldBoundaryShape2D.new()
	top.normal = Vector2.DOWN
	
	var bottom = WorldBoundaryShape2D.new()
	bottom.normal = Vector2.UP
	
	_add_body(left, $ColorRect.position)
	_add_body(right, Vector2($ColorRect.position.x + $ColorRect.size.x, $ColorRect.position.y))
	_add_body(top, $ColorRect.position)
	_add_body(bottom, Vector2($ColorRect.position.x, $ColorRect.position.y + $ColorRect.size.y))

func _add_body(boundary_shape, body_position):
	var physics = StaticBody2D.new()
	var shape = CollisionShape2D.new()
	physics.global_position = body_position
	shape.shape = boundary_shape
	physics.add_child(shape)
	add_child(physics)
