extends Node2D

func _ready():
	if ProfileManager.get_current_profile_id() != null:
		%SceneManager._switch_scene("res://main_menu.tscn", null)
	else:
		%SceneManager._switch_scene("res://first_boot_profile_manager_ui.tscn", null)
