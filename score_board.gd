extends Control

var NEW_SCORE_LABEL = preload("res://new_score_label.tscn")

#	current_times.append({
#		level_id = level_id,
#		player_name = player_name,
#		level_time = level_time,
#		when_recorded = Time.get_unix_time_from_system()
#	})

func show_scores(scores, is_dead):
	for child in %Scores.get_children():
		child.queue_free()
		
	var latest_score
	var latest_score_when = 0
	for score in scores:
		if score.when_recorded > latest_score_when and not is_dead:
			latest_score = score
			latest_score_when = score.when_recorded
			
	scores.resize(mini(scores.size(), 10))
	
	for score in scores:
		var player_label = Label.new()
		var player_name = ProfileManager.get_profile_by_id(score.player_id).player_name
		player_label.text = player_name
		var time_label = Label.new()
		time_label.text = Utils.get_time_label(score.level_time)
		
		var hbox = HBoxContainer.new()
		hbox.add_child(player_label)
		hbox.add_child(time_label)
		
		if score == latest_score:
			var latest_label := NEW_SCORE_LABEL.instantiate()
			latest_label.text = "NEW!"
			#latest_label.rotation_degrees = 10
			#latest_label.ov
			time_label.add_theme_color_override("font_color", Colors.get_current_palette().accent_b)
			player_label.add_theme_color_override("font_color", Colors.get_current_palette().accent_b)
			hbox.add_child(latest_label)
		
		%Scores.add_child(hbox)
