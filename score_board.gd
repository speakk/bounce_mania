extends Control

#	current_times.append({
#		level_id = level_id,
#		player_name = player_name,
#		level_time = level_time,
#		when_recorded = Time.get_unix_time_from_system()
#	})

func show_scores(scores):
	for child in %Scores.get_children():
		child.queue_free()
		
	var latest_score
	var latest_score_when = 0
	for score in scores:
		if score.when_recorded > latest_score_when:
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
			var latest_label = Label.new()
			latest_label.text = "New!"
			hbox.add_child(latest_label)
		
		%Scores.add_child(hbox)
