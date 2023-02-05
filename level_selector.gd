extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	_refresh_level_list(ProfileManager.get_current_profile_id())
	Events.current_profile_changed.connect(_refresh_level_list)

func _refresh_level_list(player_name):
	if player_name == null:
		%NoPlayerLabel.visible = true
		%LevelListContainer.visible = false
	else:
		%NoPlayerLabel.visible = false
		%LevelListContainer.visible = true
		
	var current_user_level = ProfileManager.get_user_level_progress(player_name)
	
	for level in %LevelList.get_children():
		level.queue_free()
	
	for i in Levels.levels.size():
		var level = Levels.levels[i]
		var button := Button.new()
		var description = "\n%s" % level.get("title") if level.get("title") else ""
		button.text = "%s%s" % [level.name, description]
		button.custom_minimum_size.x = 160
		button.custom_minimum_size.y = 60
		if i <= current_user_level:
			button.pressed.connect(_change_level.bind(level.id))
		else:
			button.modulate = Color(1,1,1,0.2)
		
		%LevelList.add_child(button)

func _change_level(level_id):
	Events.level_change_pressed.emit(level_id)
