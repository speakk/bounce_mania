extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.level_timer_changed.connect(_level_timer_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _level_timer_changed(time: float):
	text = Utils.get_time_label(time)
