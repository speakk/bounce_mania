extends RigidBody2D

#@export var speed: int = 900
@export var speed: int = 400
@export var bounce_speed: int = 500
@export var bounce_time: float = 0.5
@export var damage: float = 10

@onready var COLLISION_PARTICLES = preload("res://collision_particles.tscn")
@onready var FUSE = preload("res://fuse.tscn")

var bouncing = false

var velocity = Vector2()

var dash_timeout: float = GlobalValues.player_dash_charge_timeout
		
var bounce_timer: float = dash_timeout:
	set(value):
		Events.bounce_timer_changed.emit(value)
		bounce_timer = value

var bounce_duration: float = 1
var bounce_on_timer: float = bounce_duration

var is_player = true

var current_damage = damage

var has_moved = false

var fuse

func _ready():
	Events.palette_changed.connect(_on_palette_changed)
	Events.level_loaded.connect(_on_level_loaded)
	_on_palette_changed(Colors.get_current_palette(), null, null)
	Events.in_game_paused.connect(_on_paused)
	Events.in_game_resumed.connect(_on_resumed)
	#fuse = FUSE.instantiate()
	#add_child(fuse)
	#get_parent().add_child(fuse)
	#$RemoteTransform2D.remote_path = "../../Fuse"

func _on_paused():
	#paused = true
	pass
	
func _on_resumed():
	pass

func _on_level_loaded(_a):
	bounce_timer = dash_timeout

#func _process(_delta):
#	if Input.is_action_pressed("bounce"):
#		physics_material_override.bounce = 0
#		physics_material_override.friction = 0
#	else:
#		physics_material_override.bounce = 0.5
#		physics_material_override.friction = 0.03

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
#	if Input.is_action_pressed("down"):
#		velocity.y += 1
#	if Input.is_action_pressed("up"):
#		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if Input.is_action_just_pressed("bounce"):
		var direction = (get_global_mouse_position() - position).normalized()
		var vector = direction * bounce_speed
		bounce(vector)
		
	
	if not has_moved and linear_velocity.length_squared() > 0:
		Events.player_has_moved.emit()
		has_moved = true
	
func _on_palette_changed(new_palette, _a, _b):
	$Circle.color = new_palette.neutral_a
	$Circle.color.v = minf(0.5, $Circle.color.v)
	$Circle/Circle.color = $Circle.color.lightened(0.4)
	$Circle/Circle2.color = $Circle.color.lightened(0.4)

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
	direct_eye($Circle/LeftEyeSprite, Vector2(-8, y_offset))
	direct_eye($Circle/RightEyeSprite, Vector2(7, y_offset))

func show_direction_indicator():
	var direction = (get_global_mouse_position() - position).normalized()
	$DirectionIndicator.set_direction(direction)

#func _physics_process(delta):
	

func _physics_process(delta):
	get_input()
	direct_eyes()
	show_direction_indicator()
	
	#fuse.global_position = global_position
	#fuse.move_and_collide()
	
	if not bouncing and has_moved:
		if bounce_timer > 0:
			bounce_timer -= delta
		else:
			bounce_timer = 0
			Events.player_dash_charged.emit()
	
	if bouncing:
		bounce_on_timer -= delta
		if bounce_on_timer <= 0:
			set_bounce_off()
	
	apply_central_impulse(velocity * delta)


func bounce(direction):
	if not bouncing and bounce_timer == 0:
		bounce_timer = dash_timeout
		set_bounce_on(direction)

func set_bounce_on(direction):
	#physics_material_override.bounce = 0
	#physics_material_override.friction = 0
	linear_velocity = Vector2(0, 0)
	apply_impulse(direction)
	bouncing = true
	bounce_on_timer = bounce_duration
	#bounce_timer.start(bounce_time)
	$TrailParticles.emitting = true
	current_damage = damage * 2
	set_collision_mask_value(2, false)
	Events.player_bounce_started.emit()

func set_bounce_off():
	#physics_material_override.bounce = 0.5
	#physics_material_override.friction = 0.03
	bouncing = false
	$TrailParticles.emitting = false
	current_damage = damage
	set_collision_mask_value(2, true)
	bounce_timer = dash_timeout
	Events.player_bounce_ended.emit()
	

func handle_colision_particles(collision_position, speed_factor):
	var collision_particles := COLLISION_PARTICLES.instantiate()
	collision_particles.position = collision_position
	get_parent().add_child(collision_particles)
	collision_particles.amount = log(speed_factor) * 2
	collision_particles.process_material.initial_velocity_max = minf(speed_factor, 140)
	collision_particles.start()
	await collision_particles.finished
	collision_particles.queue_free()

func _on_area_2d_body_entered(body):
	$Circle._current_color = $Circle.color.lightened(0.6)
	var shadertween = get_tree().create_tween()
	shadertween.tween_property($Circle, "_current_color", $Circle.color, 0.2)
	
	if body.is_in_group("bricks"):
		Events.brick_hit.emit(body, self, self.current_damage)
	
	$Circle.scale = Vector2(1.4, 1.4)
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("Circle"), "scale", Vector2(1, 1), 0.3)

#func handle_squish(point, linear_velocity):
#	#print("OK HIT", linear_velocity)
#	var new_scale = linear_velocity.abs().normalized()
#	print("new_scale", new_scale)
#	$Circle.scale = new_scale
#	#$Circle.scale = Vector2(0.5, 1)
#	#$Circle.scale = 
#
#func shake_camera(hit_velocity):
#	var length = hit_velocity.length() / 600
#	print("length", length)
#	#$ShakeCamera2D.add_trauma(length)

func _integrate_forces(state):
	for i in get_contact_count():
		var point = state.get_contact_local_position(i)
		var contact_object = state.get_contact_collider_object(i)
		var is_wall = contact_object.get_collision_layer_value(1)
		
		if is_wall:
			handle_colision_particles(point, linear_velocity.length_squared() / 500)
			var hit_speed = linear_velocity.length_squared()
			Events.player_collision_happened.emit(hit_speed)
			#shake_camera(linear_velocity)
			#handle_squish(point, linear_velocity)
			
			#var wall_grind_boost = 5
			#linear_velocity += linear_velocity.normalized() * wall_grind_boost
