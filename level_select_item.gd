extends MarginContainer

signal selected(level_id)

func set_details(level, is_available):
	var description = "\n%s" % level.get("title") if level.get("title") else ""
	var button = %Button
	button.text = "%s%s" % [level.name, description]
	if is_available:
		#button.pressed.connect(_change_level.bind(level.id))
		button.pressed.connect(func(): selected.emit(level.id))
	else:
		button.modulate = Color(1,1,1,0.2)
	
	var star_display = %StarDisplay
	star_display.set_star_level_requirements(Levels.get_star_requirements(level.id))
	var best_time = ProfileManager.get_best_time(ProfileManager.get_current_profile_id(), level.id)
	
	if best_time != null:
		star_display.set_star_level_reached(Levels.get_star_level_reached(level.id, best_time))
