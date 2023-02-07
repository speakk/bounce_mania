extends PanelContainer

signal new_player_added(player_id)

# Called when the node enters the scene tree for the first time.
func _ready():
	_refresh_players_list(ProfileManager.get_existing_profiles())
	Events.player_list_changed.connect(_refresh_players_list)

func _refresh_players_list(existing_players):
	for child in %ExistingPlayersList.get_children():
		child.queue_free()
	
	var current_profile_id = ProfileManager.get_current_profile_id()
	
	for player in existing_players.values():
		var hbox = HBoxContainer.new()
		var button = Button.new()
		button.text = player.player_name
		if current_profile_id == player.id:
			button.text += " (selected)"
		button.pressed.connect(_select_player.bind(player.id))
		
		var remove_button = Button.new()
		remove_button.text = "Delete"
		remove_button.pressed.connect(_remove_player.bind(player.id))
		
		hbox.add_child(button)
		hbox.add_child(remove_button)
		%ExistingPlayersList.add_child(hbox)
	
	if existing_players.size() == 0:
#		var label = Label.new()
#		label.text = "No players"
#		%ExistingPlayersList.add_child(label)
		%ExistingPlayersContainer.hide()

func _select_player(player_id):
	ProfileManager.set_current_profile_id(player_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_add_new_player_button_pressed():
	var player_name = %AddNewPlayerTextBox.text
	ProfileManager.save_new_profile(player_name)
	new_player_added.emit(player_name)

func _remove_player(player_id):
	ProfileManager.remove_profile(player_id)
