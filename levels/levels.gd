extends Node

const levels = [
	{
		name = "Level 1",
		id = "level_1",
		path = "res://levels/level_1.tscn"
	},
	{
		name = "Level 2",
		id = "level_2",
		path = "res://levels/level_2.tscn"
	},
]

var levels_by_id = {}

func _ready():
	for level in levels:
		levels_by_id[level.id] = level

func get_by_id(id):
	return levels_by_id.get(id)

var level_times_path = "user://level_times.save"

func save_level_time(level_id, player_name, level_time):
	#var save_game = File.new()
	var save_object = {}
	if FileAccess.file_exists(level_times_path):
		var file = FileAccess.open(level_times_path, FileAccess.READ)
		save_object = JSON.parse_string(file.get_as_text())
	
	var current_times = save_object.get(level_id)
	if current_times == null:
		current_times = []
	
	current_times.append({
		level_id = level_id,
		player_name = player_name,
		level_time = level_time,
		when_recorded = Time.get_unix_time_from_system()
	})
	
	current_times.sort_custom(func(a, b): return a.level_time < b.level_time)
	current_times.resize(mini(current_times.size(), 100))
	
	save_object[level_id] = current_times
	
	var file = FileAccess.open(level_times_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_object))

func get_level_times(level_id):
	if FileAccess.file_exists(level_times_path):
		var file = FileAccess.open(level_times_path, FileAccess.READ)
		var save_object = JSON.parse_string(file.get_as_text())
		var current_times = save_object.get(level_id)
		return current_times
	
	return []
