extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.level_finished.connect(_level_finished)
	%ScoreBoard.show_scores(Levels.get_level_times("level_1"))

func _level_finished(level_id, time):
	%TimeLabel.text = "Your time: %s" % Utils.get_time_label(time)
	%ScoreBoard.show_scores(Levels.get_level_times(level_id))
	var next_level = Levels.get_next_level(level_id)
	if next_level != null:
		%NextLevelButton.visible = true
	else:
		%NextLevelButton.visible = false
	
	var star_levels = Levels.get_by_id(level_id).get("stars").values()
	print("star_levels", star_levels)
	var level_reached = null
	for i in range(star_levels.size()-1,-1,-1):
		if time < star_levels[i]:
			level_reached = i
			break
	
	%StarSectionContainer.set_star_level_requirements(Levels.get_star_requirements(level_id))
	%StarSectionContainer.set_star_level_reached(level_reached)
	
func _on_try_again_button_pressed():
	Events.try_again_pressed.emit()


func _on_leve_l_selection_button_pressed():
	Events.new_game_pressed.emit()

func _on_next_level_button_pressed():
	Events.next_level_pressed.emit()
