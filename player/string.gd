extends Node2D


@export var ropeLength: float = 40
var originalRopeLength: float = ropeLength
@export var constrain: float = 1	# distance between points
@export var gravity: Vector2 = Vector2(0,9.8)
@export var dampening: float = 0.9
@export var startPin: bool = true
@export var endPin: bool = true

@onready var line2D: = $Line2D

var pos: PackedVector2Array
var posPrev: PackedVector2Array
var pointCount: int

var max_time := 0.0

func _level_timer_changed(level_time):
	var current_segment = round(originalRopeLength - (level_time / max_time * originalRopeLength) + 1)
	print("Current", current_segment)
	if current_segment != ropeLength:
		ropeLength = current_segment
		print("points before", pointCount)
		pointCount = get_pointCount(ropeLength)
		print("points after", pointCount)
		resize_arrays()
		
		if pointCount <= 0 and has_node("Sparks"):
			$Sparks.queue_free()
	
	
#	var current_segment = round(amount_of_segments - (level_time / max_time * amount_of_segments) + 1)
#
#	if current_segment < segments.size() + 1 and current_segment > 0:
#		var last_segment = segments.back()
#		var sparks = last_segment.get_node("sparks")
#		last_segment.remove_child(sparks)
#		last_segment.queue_free()
#		segments.resize(segments.size() - 1)
#
#		var new_last = segments.back()
#		if new_last:
#			new_last.add_child(sparks)
#			sparks.global_position = new_last.global_position - Vector2.from_angle(-new_last.rotation) * segment_length
#			sparks.rotation = new_last.rotation

func _level_loaded(level_id):
	max_time = Levels.get_by_id(level_id).get("stars")[0]

func _ready()->void:
	Events.level_timer_changed.connect(_level_timer_changed)
	Events.level_loaded.connect(_level_loaded)
	
	pointCount = get_pointCount(ropeLength)
	resize_arrays()
	init_position()

func get_pointCount(distance: float)->int:
	return int(ceil(distance / constrain))

func resize_arrays():
	pos.resize(pointCount)
	posPrev.resize(pointCount)

func init_position()->void:
	for i in range(pointCount):
		pos[i] = global_position + Vector2(constrain *i, 0)
		posPrev[i] = global_position + Vector2(constrain *i, 0)
	#global_position = Vector2.ZERO

#func _unhandled_input(event:InputEvent)->void:
#	if event is InputEventMouseMotion:
#		if Input.is_action_pressed("click"):	#Move start point
#			set_start(get_global_mouse_position())
#		if Input.is_action_pressed("right_click"):	#Move start point
#			set_last(get_global_mouse_position())
#	elif event is InputEventMouseButton && event.is_pressed():
#		if event.button_index == 1:
#			set_start(get_global_mouse_position())
#		elif event.button_index == 2:
#			set_last(get_global_mouse_position())

func _process(delta)->void:
	global_rotation = 0
	# TODO: Absolutely dirty hack, boo!
	# Fix this to properly copy global position but keep offset of local position
	set_start(get_parent().get_node("FuseStartLine").global_position)
	global_position = Vector2(0,0)
	update_points(delta)
	update_constrain()
	
	if pos.size() > 0:
		$Sparks.global_position = pos[pos.size() - 1]
	#update_constrain()	#Repeat to get tighter rope
	#update_constrain()
	
	# Send positions to Line2D for drawing
	line2D.points = pos

func set_start(p:Vector2)->void:
	if pos.size() > 0:
		pos[0] = p
		posPrev[0] = p

func set_last(p:Vector2)->void:
	pos[pointCount-1] = p
	posPrev[pointCount-1] = p

func update_points(delta)->void:
	for i in range (pointCount):
		# not first and last || first if not pinned || last if not pinned
		if (i!=0 && i!=pointCount-1) || (i==0 && !startPin) || (i==pointCount-1 && !endPin):
			var velocity = (pos[i] -posPrev[i]) * dampening
			posPrev[i] = pos[i]
			pos[i] += velocity + (gravity * delta)

func update_constrain()->void:
	for i in range(pointCount):
		if i == pointCount-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		
		# if first point
		if i == 0:
			if startPin:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		# if last point, skip because no more points after it
		elif i == pointCount-1:
			pass
		# all the rest
		else:
			if i+1 == pointCount-1 && endPin:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)

