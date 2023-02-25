extends "res://obstacle.gd"

@export var opening_speed := 1.0
@export var is_open := false
@export var door_id := "end_door"

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	add_to_group("doors")
	
	if is_open:
		self.scale = Vector2(1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func toggle():
	if is_open:
		get_tree().create_tween().tween_property(self, "scale", Vector2(1, 1), opening_speed)
		print("Closing door?")
	else:
		get_tree().create_tween().tween_property(self, "scale", Vector2(1, 0), opening_speed)
		print("Opening door?")

	is_open = !is_open
