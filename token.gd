extends Node2D

var PARTICLES = preload("res://token_collect_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	print("ein")
	if body.is_in_group("players"):
		Events.token_collected.emit(self)
		var particles = PARTICLES.instantiate()
		particles.position = position
		get_parent().add_child(particles)
		particles.get_node("GPUParticles2D").emitting = true
		queue_free()
