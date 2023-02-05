extends Control

var time_colors = [Color("aa6a4e"), Color("8faeb4"), Color("d4b847")]
var _max_time = 0

func _ready():
	Events.level_timer_changed.connect(_level_timer_changed)
	
func _level_timer_changed(new_time):
	$ProgressBar.value = new_time / _max_time * 100
	if $ProgressBar.value >= 100:
		$ProgressBar.modulate = Color(1, 0, 0)

func set_level_times(level_times: Array):
	for child in $TimeLimitRects.get_children():
		child.queue_free()
	
	var highest_time = level_times.front()
	_max_time = highest_time
	
	var max_width = $ProgressBar.custom_minimum_size.x
	
	for level_time in level_times:
		var rect := ColorRect.new()
		#rect.position = $ProgressBar.position - Vector2($ProgressBar.custom_minimum_size.x / 2, 0)
		rect.position = $ProgressBar.position
		rect.custom_minimum_size.x = float(level_time) / float(highest_time) * max_width
		
		rect.custom_minimum_size.y = $ProgressBar.custom_minimum_size.y
		rect.color = time_colors[level_times.find(level_time)]
		
		$TimeLimitRects.add_child(rect)
		
