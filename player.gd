extends RigidBody2D

@export var speed: int = 1200
@export var bounce_speed: int = 1000
@export var bounce_time: float = 0.5
@export var damage: float = 10

@onready var COLLISION_PARTICLES = preload("res://collision_particles.tscn")

var bouncing = false

var velocity = Vector2()
var bounce_timer

var is_player = true

var current_damage = damage

var has_moved = false

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if Input.is_action_just_pressed("bounce"):
		var direction = (get_global_mouse_position() - position).normalized()
		var vector = direction * bounce_speed
		bounce(vector)
	
	if not has_moved and linear_velocity.length_squared() > 0:
		Events.player_has_moved.emit()
		has_moved = true
	
func _ready():
	$Sprite2D.frame = 0
	bounce_timer = Timer.new()
	add_child(bounce_timer)

var max_dist = 2

func direct_eye(eye, offset):
	var eye_pos = eye.global_position
	var player_pos = position + offset
	var dir = eye_pos.direction_to(get_global_mouse_position())
	dir = dir.rotated(-rotation)
	var dist = eye_pos.distance_to(get_local_mouse_position())
	eye.position = dir * min(dist, max_dist) + offset

func direct_eyes():
	var y_offset = 5
	direct_eye($LeftEyeSprite, Vector2(-8, y_offset))
	direct_eye($RightEyeSprite, Vector2(7, y_offset))

func show_direction_indicator():
	var direction = (get_global_mouse_position() - position).normalized()
	$DirectionIndicator.set_direction(direction)

func _process(delta):
	get_input()
	apply_force(velocity)
	direct_eyes()
	show_direction_indicator()

func bounce(direction):
	if not bouncing:
		#linear_velocity = Vector2(0, 0)
		apply_impulse(direction)
		$Sprite2D.frame = 1
		bouncing = true
		bounce_timer.start(bounce_time)
		$TrailParticles.emitting = true
		current_damage = damage * 2
		set_collision_mask_value(2, false)
		
		await bounce_timer.timeout
		
		bouncing = false
		$Sprite2D.frame = 0
		$TrailParticles.emitting = false
		current_damage = damage
		set_collision_mask_value(2, true)
		
		


#func _on_physics_body_body_entered(body):
#	if body.is_in_group("bricks"):
#		print("emit")
#		#Events.emit_signal("brick_hit", self, self.current_damage)
#		Events.brick_hit.emit(body, self, self.current_damage)

func handle_colision_particles():
	var collision_particles = COLLISION_PARTICLES.instantiate()
	#collision_particles.restart()
	collision_particles.position = position
	get_parent().add_child(collision_particles)
	collision_particles.start()
	#collision_particles.emitting = true
	await collision_particles.finished
	print("Finished")
	collision_particles.queue_free()
	#await 

func _on_area_2d_body_entered(body):
	handle_colision_particles()
	
	$Sprite2D.material.set_shader_parameter("white_progress", 0.5)
	var shadertween = get_tree().create_tween()
	shadertween.tween_property($Sprite2D.material, "shader_parameter/white_progress", 0, 0.2)
	
	if body.is_in_group("bricks"):
		print("emit")
		#Events.emit_signal("brick_hit", self, self.current_damage)
		Events.brick_hit.emit(body, self, self.current_damage)
	
	$Sprite2D.scale = Vector2(1.4, 1.4)
	#$/Sprite2D.material.
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("Sprite2D"), "scale", Vector2(1, 1), 0.2)


#func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
#	var body_shape_owner = body.shape_find_owner(body_shape_index)
#	var body_shape_node = body.shape_owner_get_owner(body_shape_owner)
#	var body_global_transform = body_shape_node.global_transform
#
#	var local_shape_owner = shape_find_owner(local_shape_index)
#	var local_shape_node = shape_owner_get_owner(local_shape_owner)
#
#	var area_global_transform = local_shape_node.global_transform
#
#	var collision_points = local_shape_node.shape.collide_and_get_contacts(area_global_transform,
#							body_shape_node,
#							body_global_transform)
#	print(collision_points)
