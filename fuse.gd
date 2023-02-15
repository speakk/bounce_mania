extends CharacterBody2D

func _ready():
	var amount_of_segments = 6
	var segment_length = 6
	
	var segments = []

	for i in range(amount_of_segments):
		var segment = $FuseSegment.duplicate()
		segment.position.y = segment_length * i
		print("segment pos", segment.position)
		segments.push_back(segment)
		segment.name = "segment_%s" % i
		add_child(segment)
	
	for i in range(amount_of_segments):
		var pin_joint = PinJoint2D.new()
		pin_joint.position.y = (segment_length) * (i)
		print("pin joint pos", pin_joint.position)
		pin_joint.disable_collision = true
		if i == 0:
			pin_joint.node_a = NodePath("../../Fuse")
			pin_joint.node_b = NodePath("../segment_%s" % i)
		else:
			pin_joint.node_a = NodePath("../segment_%s" % (i - 1))
			pin_joint.node_b = NodePath("../segment_%s" % i)
		#pin_joint.node_a = "segment_%s" % i
		#pin_joint.node_b = "segment_%s" % (i + 1)
		
		add_child(pin_joint)
	
