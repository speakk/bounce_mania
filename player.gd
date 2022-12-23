extends RigidBody2D

@export var speed: int = 1200
@export var bounce_speed: int = 1000
@export var bounce_time: float = 0.5
@export var damage: float = 10

var bouncing = false

var velocity = Vector2()
var bounce_timer

var current_damage = damage

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

func _process(delta):
	get_input()
	apply_force(velocity)
	direct_eyes()

	if Input.is_action_just_pressed("bounce"):
		var direction = (get_global_mouse_position() - position).normalized()
		var vector = direction * bounce_speed
		bounce(vector)
	
	
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



func _on_area_2d_body_entered(body):
	print("Entered?")
	if body.is_in_group("bricks"):
		print("emit")
		#Events.emit_signal("brick_hit", self, self.current_damage)
		Events.brick_hit.emit(body, self, self.current_damage)
	
	$Sprite2D.scale = Vector2(1.4, 1.4)
	#$/Sprite2D.material.
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("Sprite2D"), "scale", Vector2(1, 1), 0.2)
