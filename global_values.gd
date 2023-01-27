extends Node

const player_dash_charge_timeout = 1

var existing_players_path = "user://players.save"

func get_players_save_object():
	if FileAccess.file_exists(existing_players_path):
		var file = FileAccess.open(existing_players_path, FileAccess.READ)
		print("ERRORRRR:", file.get_open_error())
		var save_object = JSON.parse_string(file.get_as_text())
		print("File existed right?", save_object)
		return save_object

func get_existing_players():
	var save_object = get_players_save_object() if get_players_save_object() else {}
	print("save object?", save_object)
	var existing_players = save_object.get("players")
	print("Returning existing", existing_players)
	return existing_players if existing_players else []

func remove_player(original_name):
	print("removing player", original_name)
	var player_name = original_name
	
	var save_object = get_players_save_object() if get_players_save_object() else {}
	var existing_players = save_object.get("players") if save_object.get("players") else []
	
	if not existing_players.has(player_name):
		return false
	
	existing_players.erase(player_name)
	#existing_players.remo(player_name)
	save_object["players"] = existing_players
	
	var file = FileAccess.open(existing_players_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_object))
	file = null
	
	Events.player_list_changed.emit(existing_players)
	print("changed by removal, players", existing_players)
	
	return true

func save_player(original_name):
	print("saving player", original_name)
	#var player_name = original_name.json_escape()
	var player_name = original_name
	var save_object = get_players_save_object() if get_players_save_object() else {}
	var existing_players = save_object.get("players") if save_object.get("players") else []
	
	if existing_players.has(player_name):
		return false
	
	existing_players.append(player_name)
	save_object["players"] = existing_players
	
	var file = FileAccess.open(existing_players_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_object))
	file = null
	
	
	Events.player_list_changed.emit(existing_players)
	print("changed, players", existing_players)
	
	return true

func set_current_player(original_name):
	var player_name = original_name
	var save_object = get_players_save_object() if get_players_save_object() else {}
	save_object["current_player"] = player_name
	
	var file = FileAccess.open(existing_players_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_object))
	file = null
	
	Events.player_list_changed.emit(save_object.get("players"))

func get_current_player():
	var save_object = get_players_save_object() if get_players_save_object() else {}
	return save_object.get("current_player")
