extends RigidBody2D

const BricksParticles = preload("res://brick_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Health.health_zero.connect(_on_health_zero)
	$Health.health_changed.connect(_on_health_changed)
	#Events.connect("brick_hit", self, _on_brick_hit)
	Events.brick_hit.connect(_on_brick_hit)
	add_to_group("bricks")

func _on_brick_hit(brick, by, damage):
	if brick != self:
		return
		
	var particle = BricksParticles.instantiate()
	particle.restart()
	particle.position = position
	get_parent().add_child(particle)
	particle.emitting = true
	#$RigidBody2D/GPUParticles2D.restart()
	#$RigidBody2D/GPUParticles2D.emitting = true
	
	
	$Health.take_damage(damage)
	
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	$Brick.position = Vector2(0,0)

func _on_health_zero():
	queue_free()
	
func _on_health_changed(value):
	if value <= 10:
		$Brick.frame = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _on_static_body_2d_body_entered(body):

