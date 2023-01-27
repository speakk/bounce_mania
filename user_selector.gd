extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	_refresh_players_list(GlobalValues.get_existing_players())
	Events.player_list_changed.connect(_refresh_players_list)

func _refresh_players_list(existing_players):
	print("Refreshing", existing_players)
	for child in %ExistingPlayersList.get_children():
		child.queue_free()
	
	var current_player = GlobalValues.get_current_player()
	
	for player in existing_players:
		var hbox = HBoxContainer.new()
		var button = Button.new()
		button.text = player
		if current_player == player:
			button.text += " (selected)"
		button.pressed.connect(_select_player.bind(player))
		
		var remove_button = Button.new()
		remove_button.text = "Delete"
		remove_button.pressed.connect(_remove_player.bind(player))
		
		hbox.add_child(button)
		hbox.add_child(remove_button)
		%ExistingPlayersList.add_child(hbox)

func _select_player(player_name):
	GlobalValues.set_current_player(player_name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_new_player_button_pressed():
	var player_name = %AddNewPlayerTextBox.text
	GlobalValues.save_player(player_name)

func _remove_player(player_name):
	GlobalValues.remove_player(player_name)
