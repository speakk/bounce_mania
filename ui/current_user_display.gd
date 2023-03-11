extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.current_profile_changed.connect(_current_profile_changed)
	_current_profile_changed(ProfileManager.get_current_profile_id())

func _current_profile_changed(player):
	if player:
		$MarginContainer/Label.text = "Current player: %s" % player
	else:
		$MarginContainer/Label.text = "No player selected. Visit the Profile Manager!"
