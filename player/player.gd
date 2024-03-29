extends RigidBody2D

#@export var speed: int = 900
@export var speed: int = 400
@export var bounce_speed: int = 500
@export var bounce_time: float = 0.5
@export var damage: float = 10
@export var bounce_duration: float = 0.5
@export var is_dead: bool = false:
	set(value):
		if not is_dead:
			Events.player_died.emit()
			transform_player_into_dead()
		is_dead = value

var bounce_on_timer: float = bounce_duration


@export var slowdown_power_amount: float = 0.0:
	set(value):
		Events.slow_power_amount_changed.emit(value)
		slowdown_power_amount = value
		
@export var slowdown_power_amount_max: float = 1.0
@export var slowdown_usage_rate: float = 2
@export var slowdown_recharge_rate: float = 0.5

var slow_down_speed = 0.23
var normal_speed = 1.0
var time_lerp_speed = 0.2

@onready var COLLISION_PARTICLES = preload("res://collision_particles.tscn")
@onready var EXPLOSION_PARTICLES = preload("res://player/player_explosion.tscn")
@onready var FUSE = preload("res://player/fuse.tscn")

var bouncing = false

var velocity = Vector2()

var dash_timeout: float = GlobalValues.player_dash_charge_timeout
		
var bounce_timer: float = dash_timeout:
	set(value):
		Events.bounce_timer_changed.emit(value)
		bounce_timer = value

var is_player = true

var current_damage = damage

var has_moved = false

var fuse

func _ready():
	Events.palette_changed.connect(_on_palette_changed)
	Events.level_loaded.connect(_on_level_loaded)
	_on_palette_changed(Colors.get_current_palette(), null, null)
	Events.level_max_time_reached.connect(_level_max_time_reached)
	#fuse = FUSE.instantiate()
	#add_child(fuse)
	#get_parent().add_child(fuse)
	#$RemoteTransform2D.remote_path = "../../Fuse"

func transform_player_into_dead():
	var explosion = EXPLOSION_PARTICLES.instantiate()
	add_child(explosion)
	#explosion.position = position
	explosion.emitting = true
	#explosion.process_material.
	
	$Circle/Circle.visible = false
	$Circle/Circle2.visible = false
	$Circle/LeftEyeSprite.visible = false
	$Circle/RightEyeSprite.visible = false
	
	$Circle/DeadEyes.visible = true
	
func _level_max_time_reached():
	if not is_dead:
		is_dead = true

func _on_level_loaded(_a):
	bounce_timer = dash_timeout
	slowdown_power_amount = 0

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	#if Input.is_action_pressed("down"):
	#	velocity.y += 1
#	if Input.is_action_pressed("jump"):
#		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if Input.is_action_just_pressed("bounce"):
		var direction = (get_global_mouse_position() - position).normalized()
		var vector = direction * bounce_speed
		bounce(vector)
	
	if Input.is_action_just_pressed("start_level") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		Events.player_has_moved.emit()
		has_moved = true
		freeze = false
	
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

var blink_speed = 0.2
func blink():
	$Circle/LeftEyeSprite.scale.y = 0
	$Circle/RightEyeSprite.scale.y = 0
	$Circle/Circle.scale.y = 0
	$Circle/Circle2.scale.y = 0
	get_tree().create_tween().tween_property($Circle/LeftEyeSprite, "scale", Vector2(1, 1), blink_speed)
	get_tree().create_tween().tween_property($Circle/RightEyeSprite, "scale", Vector2(1, 1), blink_speed)
	get_tree().create_tween().tween_property($Circle/Circle, "scale", Vector2(1, 1), blink_speed)
	get_tree().create_tween().tween_property($Circle/Circle2, "scale", Vector2(1, 1), blink_speed)

var last_blink = 0
var blink_min_interval = 1000
var blink_max_interval = 4000
var blink_next = blink_min_interval
func handle_blinking():
	if blink_next < Time.get_ticks_msec():
		blink()
		blink_next = Time.get_ticks_msec() + randf_range(blink_min_interval, blink_max_interval)

func _process(delta):
	handle_blinking()
	if has_moved:
		slowdown_power_amount += slowdown_recharge_rate * delta
		slowdown_power_amount = clampf(slowdown_power_amount, -1, slowdown_power_amount_max)
		
func _physics_process(delta):
#	if Input.is_action_pressed("disable_bounce"):
#		physics_material_override.bounce = 0
#		physics_material_override.friction = 0
#	else:
#		physics_material_override.bounce = 0.5
#		physics_material_override.friction = 0.01

#	if Input.is_action_pressed("disable_bounce"):
#		physics_material_override.friction = 1
#	else:
#		physics_material_override.friction = 0.01

#	if Input.is_action_pressed("slowdown") and slowdown_power_amount >= 0:
#		Engine.time_scale = lerpf(Engine.time_scale, slow_down_speed, time_lerp_speed)
#		slowdown_power_amount -= slowdown_usage_rate * delta
#		if slowdown_power_amount < 0:
#			slowdown_power_amount = -1
#	else:
#		Engine.time_scale = lerpf(Engine.time_scale, normal_speed, time_lerp_speed)
	
	get_input()
	direct_eyes()
	show_direction_indicator()

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
	if speed_factor < 10:
		return
	var collision_particles := COLLISION_PARTICLES.instantiate()
	collision_particles.position = collision_position
	get_parent().add_child(collision_particles)
	collision_particles.amount = log(speed_factor) * 2
	collision_particles.process_material.initial_velocity_max = minf(speed_factor, 140)
	collision_particles.start()
	await collision_particles.finished
	collision_particles.queue_free()

func _on_area_2d_body_entered(body):
	$Circle._current_color = Color.WHITE;
	var shadertween = get_tree().create_tween()
	shadertween.tween_property($Circle, "_current_color", $Circle.color, 0.2)
	
	if body.is_in_group("bricks"):
		Events.brick_hit.emit(body, self, self.current_damage)
	
	$Circle.scale = Vector2(1.5, 1.5)
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

func _player_hit_trap():
	is_dead = true

func _integrate_forces(state):
	for i in get_contact_count():
		var point = state.get_contact_local_position(i)
		var contact_object = state.get_contact_collider_object(i)
		if contact_object == null:
			continue
		var is_wall = contact_object.get_collision_layer_value(1)
		
		if is_wall:
			handle_colision_particles(point, linear_velocity.length_squared() / 500)
			var hit_speed = linear_velocity.length_squared()
			Events.player_collision_happened.emit(hit_speed)
			if not bouncing and has_moved:
				if bounce_timer > 0:
					bounce_timer -= 0.1
			
#			if Input.is_action_pressed("disable_bounce"):
#				if point.distance_to(position) <= $Circle.size + 10:
#					linear_velocity = Vector2(0,0)
			#else:
				#physics_material_override.friction = 0.01
			
			#if Input.is_action_just_pressed("jump"):
			#	apply_central_impulse(Vector2(0, -100))
			#shake_camera(linear_velocity)
			#handle_squish(point, linear_velocity)
			
			#var wall_grind_boost = 5
			#linear_velocity += linear_velocity.normalized() * wall_grind_boost
		
		if contact_object.is_in_group("traps"):
			_player_hit_trap()
