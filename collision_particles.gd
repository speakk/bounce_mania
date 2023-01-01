extends GPUParticles2D

signal finished

func start():
	if not emitting:
		emitting = true
		await get_tree().create_timer(lifetime * (2 - explosiveness)).timeout
		emit_signal("finished")
