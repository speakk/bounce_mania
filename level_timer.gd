extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.level_timer_changed.connect(_level_timer_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _level_timer_changed(time: float):
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100
	
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	text = time_string
