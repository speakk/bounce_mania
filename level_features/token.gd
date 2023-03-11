extends Node2D

var PARTICLES = preload("res://level_features/token_collect_particles.tscn")

var offsetY = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.palette_changed.connect(_on_palette_changed)
	_on_palette_changed(Colors.get_current_palette(), null, null)

func _process(_delta):
	offsetY = sin(Time.get_ticks_msec() * 0.004) * 5
	#$Circle.position.y = position.y + offsetY
	$Circle.global_position.y = global_position.y + offsetY

func _on_palette_changed(new_palette, _a, _b):
	$Sprite2D.modulate = new_palette.accent_b.darkened(0.5)
	$PointLight2D.color = new_palette.accent_b.darkened(0.5)
	$PointLight2D.color.s += 1
	$Circle.color = new_palette.accent_b.darkened(0.3)

func _on_area_2d_body_entered(body):
	if body.is_in_group("players"):
		Events.token_collected.emit(self)
		var particles = PARTICLES.instantiate()
		particles.position = position
		get_parent().add_child(particles)
		particles.get_node("GPUParticles2D").emitting = true
		queue_free()
