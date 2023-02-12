extends PanelContainer

var LEVEL_SELECT_ITEM = preload("res://level_select_item.tscn")

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
		var level_select_item = LEVEL_SELECT_ITEM.instantiate()
		level_select_item.mouse_filter = MOUSE_FILTER_PASS
		level_select_item.set_details(Levels.levels[i], i <= current_user_level)
		%LevelList.add_child(level_select_item)
		level_select_item.selected.connect(_change_level)

func _change_level(level_id):
	Events.level_change_pressed.emit(level_id)


func _on_back_to_main_menu_button_pressed():
	Events.main_menu_pressed.emit()
