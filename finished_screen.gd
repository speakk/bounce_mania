extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.level_finished.connect(_level_finished)
	%ScoreBoard.show_scores(Levels.get_level_times("level_1"))

func _level_finished(level_id, time):
	%TimeLabel.text = "Level finished in: %s" % Utils.get_time_label(time)
	%ScoreBoard.show_scores(Levels.get_level_times(level_id))
	
func _on_try_again_button_pressed():
	Events.try_again_pressed.emit()


func _on_leve_l_selection_button_pressed():
	Events.new_game_pressed.emit()
