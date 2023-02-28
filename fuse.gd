extends CharacterBody2D

var FUSE_SEGMENT = preload("res://fuse_segment.tscn")
var SPARKS = preload("res://sparks.tscn")

var max_time = 1000
var amount_of_segments = 6
var segment_length = 5
var segments = []
var pin_joints = []

func _level_timer_changed(level_time):
	var current_segment = round(amount_of_segments - (level_time / max_time * amount_of_segments) + 1)
	
	if current_segment < segments.size() + 1 and current_segment > 0:
		var last_segment = segments.back()
		var sparks = last_segment.get_node("sparks")
		last_segment.remove_child(sparks)
		last_segment.queue_free()
		segments.resize(segments.size() - 1)
		
		var new_last = segments.back()
		if new_last:
			new_last.add_child(sparks)
			sparks.global_position = new_last.global_position - Vector2.from_angle(-new_last.rotation) * segment_length
			sparks.rotation = new_last.rotation

func _level_loaded(level_id):
	max_time = Levels.get_by_id(level_id).get("stars")[0]

func _ready():
	Events.level_timer_changed.connect(_level_timer_changed)
	Events.level_loaded.connect(_level_loaded)
	

	for i in range(amount_of_segments):
		var segment = FUSE_SEGMENT.instantiate()
		segment.position.x = 0
		segment.position.y = segment_length * i
		segments.push_back(segment)
		segment.name = "segment_%s" % i
		print("segment name: %s  position: %s" % [segment.name, segment.position])
		add_child(segment)
	
	for i in range(amount_of_segments):
		var pin_joint = PinJoint2D.new()
		pin_joint.position.y = (segment_length) * (i)
		pin_joint.disable_collision = true
		pin_joint.softness = 0.5
		if i == 0:
			pin_joint.node_a = NodePath("..")
			pin_joint.node_b = NodePath("../segment_%s" % i)
			pin_joint.bias = 1
		else:
			pin_joint.node_a = NodePath("../segment_%s" % (i - 1))
			pin_joint.node_b = NodePath("../segment_%s" % (i))
		#pin_joint.node_a = "segment_%s" % i
		#pin_joint.node_b = "segment_%s" % (i + 1)
		
		print("pin joint: %s %s %s" % [pin_joint.position, pin_joint.node_a, pin_joint.node_b])		
		
		pin_joints.push_back(pin_joint)
		add_child(pin_joint)
	
	var sparks = SPARKS.instantiate()
	sparks.name = "sparks"
	segments.back().add_child(sparks)
	sparks.position.y += segment_length
	
