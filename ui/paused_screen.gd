extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_select_button_pressed():
	Events.new_game_pressed.emit()
	get_tree().paused = false
	queue_free()

func _on_resume_button_pressed():
	Events.in_game_resumed.emit()
	queue_free()
