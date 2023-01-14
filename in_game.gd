extends Node2D

const Brick = preload("res://brick.tscn")

var level_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.end_zone_hit.connect(_on_end_zone_hit)
	
	for i in 1:
		for x in i:
			var brick = Brick.instantiate()
			var viewport_size = get_viewport_rect().size
			var brick_size = 49
			var brick_height = 20
			brick.position = Vector2(viewport_size.x/2 - brick_size * i / 2 + brick_size * x, viewport_size.y/2 + i * brick_height)
			add_child(brick)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	level_timer += delta
	Events.level_timer_changed.emit(level_timer)

func _on_end_zone_hit(zone, by):
	if "is_player" in by and by.is_player:
		print("WINNER")
