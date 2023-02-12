extends Label

var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	#rotation = sin(delta) * 0.1
	rotation = sin(time * 3) * 0.1
