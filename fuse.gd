extends CharacterBody2D

var FUSE_SEGMENT = preload("res://fuse_segment.tscn")

func _ready():
	var amount_of_segments = 6
	var segment_length = 6
	
	var segments = []

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
		pin_joint.softness = 10
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
		
		add_child(pin_joint)
	
