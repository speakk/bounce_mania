extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_user_level = Levels.get_user_level_progress(GlobalValues.player_name)
	
	for i in Levels.levels.size():
		var level = Levels.levels[i]
		var button = Button.new()
		button.text = level.name
		button.custom_minimum_size.x = 160
		button.custom_minimum_size.y = 60
		if i <= current_user_level:
			button.pressed.connect(_change_level.bind(level.id))
		else:
			button.modulate = Color(1,1,1,0.2)
		%LevelList.add_child(button)

func _change_level(level_id):
	Events.level_change_pressed.emit(level_id)
