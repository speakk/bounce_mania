extends Node2D

@export var spacing = 30
@export var size = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var new_line = $Line2D.duplicate()
		add_child(new_line)

func _process(_dt):
	global_rotation = 0

func set_direction(direction):
	for i in range(get_child_count()):
		var child = get_child(i)
		# (i+1) just because I don't want the first one to be inside the player
		child.position = direction * (i + 1) * spacing
		child.width = size - i * (size / get_child_count())
		
