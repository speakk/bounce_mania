extends Node

var save_path = "user://profiles.save"

func _ready():
	Events.first_time_player_added.connect(_first_time_player_added)

func _first_time_player_added(player_id):
	set_current_profile_id(player_id)

func get_save_object():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var save_object = JSON.parse_string(file.get_as_text())
		return save_object
	
	return {}

func save_to_file(save_object):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_object))
	
	return save_object

func get_existing_profiles() -> Dictionary:
	var save_object = get_save_object()
	var profiles = save_object.get("profiles", {})
	return profiles

func get_level_times(profile_id: String, level_id: String) -> Array:
	var times = get_existing_profiles()[profile_id].get("level_times").get(level_id, [])
	return times

func get_profile_by_id(profile_id: String):
	return get_existing_profiles()[profile_id]

# TODO: Complete this if you want functionality to show all profiles times in leaderboards
func get_all_level_times(level_id: String) -> Array:
	var all_times = []
	var profiles = get_existing_profiles()
	for profile in profiles.values():
		pass
	
	return all_times

func save_value_to_file(key, value):
	var save_object = get_save_object()
	save_object[key] = value
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_object))
	
	return save_object

func save_level_times_to_file(player_name, level_id, level_times):
	var save_object = get_save_object()
	save_object["profiles"][player_name].get("level_times")[level_id] = level_times
	save_to_file(save_object)

func remove_profile(profile_id):
	var existing_profiles = get_existing_profiles()
	
	if not existing_profiles.has(profile_id):
		return false
	
	existing_profiles.erase(profile_id)
	
	var save_object = save_value_to_file("profiles", existing_profiles)
	Events.player_list_changed.emit(existing_profiles)
	
	if save_object.get("current_profile_id") == profile_id:
		set_current_profile_id(null)
	
	return true

func save_new_profile(player_name):
	var existing_profiles = get_existing_profiles()
	
	if existing_profiles.has(player_name):
		return false
	
	existing_profiles[player_name] = {
		id = player_name,
		player_name = player_name,
		current_level = 0,
		level_times = {}
	}
	
	save_value_to_file("profiles", existing_profiles)

	Events.player_list_changed.emit(existing_profiles)
	return true

func set_current_profile_id(player_name):
	var save_object = save_value_to_file("current_profile_id", player_name)
	
	Events.player_list_changed.emit(save_object.get("profiles"))
	Events.current_profile_changed.emit(player_name)

func get_current_profile_id():
	var save_object = get_save_object()
	return save_object.get("current_profile_id")

func save_level_time(level_id: String, player_id: String, level_time: float):
	var level_times = get_level_times(player_id, level_id)
	
	level_times.append({
		level_id = level_id,
		player_id = player_id,
		level_time = level_time,
		when_recorded = Time.get_unix_time_from_system()
	})
	
	level_times.sort_custom(func(a, b): return a.level_time < b.level_time)
	level_times.resize(mini(level_times.size(), 100))
	
	save_level_times_to_file(player_id, level_id, level_times)

func save_user_level_progress(player_name, level_no):
	var save_object = get_save_object()
	save_object["profiles"][player_name]["current_level"] = level_no
	save_to_file(save_object)

func get_user_level_progress(player_name):
	var save_object = get_save_object()
	return save_object["profiles"][player_name].get("current_level", 0)
