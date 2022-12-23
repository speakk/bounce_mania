extends Node2D

const Brick = preload("res://brick.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 10:
		for x in i:
			var brick = Brick.instantiate()
			var viewport_size = get_viewport_rect().size
			var brick_size = 49
			var brick_height = 20
			brick.position = Vector2(viewport_size.x/2 - brick_size * i / 2 + brick_size * x, viewport_size.y/2 + i * brick_height)
			add_child(brick)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
