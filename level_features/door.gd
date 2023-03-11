extends "res://level_features/obstacle.gd"

@export var opening_speed := 1.0
@export var is_open := false
@export var door_id := "end_door"

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	add_to_group("doors")
	
	if is_open:
		self.scale = Vector2(1, 0)
	
	#$TextureSprite.move_child()
	var texture_sprite = $TextureSprite
	#texture_sprite.visible = true
	#remove_child($TextureSprite)
	get_node("Polygon2D").add_child(texture_sprite)
	get_node("Polygon2D").texture = texture_sprite.texture
	get_node("Polygon2D").texture_repeat = TEXTURE_REPEAT_ENABLED
	#get_node("Polygon2D").clip_children = CLIP_CHILDREN_AND_DRAW


func toggle():
	if is_open:
		get_tree().create_tween().tween_property(self, "scale", Vector2(1, 1), opening_speed)
		print("Closing door?")
	else:
		get_tree().create_tween().tween_property(self, "scale", Vector2(1, 0), opening_speed)
		print("Opening door?")

	is_open = !is_open
