extends "res://main_scenes/profile_manager_ui.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	%UserSelector.new_player_added.connect(_on_player_added)

func _on_player_added(player_id):
	Events.first_time_player_added.emit(player_id)

