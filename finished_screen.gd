extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.level_finished.connect(_level_finished)

func _level_finished(time):
	%TimeLabel.text = "Level finished in: %s" % Utils.get_time_label(time)


func _on_try_again_button_pressed():
	Events.new_game_pressed.emit()
