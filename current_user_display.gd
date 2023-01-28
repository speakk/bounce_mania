extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.current_player_changed.connect(_current_player_changed)
	_current_player_changed(GlobalValues.get_current_player())

func _current_player_changed(player):
	if player:
		$MarginContainer/Label.text = "Current player: %s" % player
	else:
		$MarginContainer/Label.text = "No player selected. Visit the Profile Manager!"
