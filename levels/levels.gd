extends Node

const levels = [
	{
		name = "Level 1",
		id = "level_1",
		path = "res://levels/level_1.tscn",
		stars = [5, 3, 1]
	},
	{
		name = "Level 2",
		id = "level_2",
		path = "res://levels/level_2.tscn",
		stars = [5, 3, 1]
	},
	{
		name = "Level 3",
		id = "level_3",
		path = "res://levels/level_3.tscn",
		stars = [5, 3, 1]
	},
	{
		name = "Level 4",
		id = "level_4",
		path = "res://levels/level_4.tscn",
		stars = [9, 3, 1]
	},
]

var levels_by_id = {}

func _ready():
	for level in levels:
		levels_by_id[level.id] = level

func get_by_id(id):
	return levels_by_id.get(id)

func get_level_index(id):
	var level = levels_by_id.get(id)
	print("get level index", id, level)
	return levels.find(level)

func get_star_level_reached(level_id, level_time):
	var star_levels = Levels.get_by_id(level_id).get("stars")
	var star_level_reached = null
	for i in range(star_levels.size()-1,-1,-1):
		if level_time < star_levels[i]:
			star_level_reached = i
			break
	
	return star_level_reached

func get_next_level(id):
	var level = levels_by_id.get(id)
	var index = levels.find(level)
	var next = index + 1
	if levels.size() >= next + 1:
		var next_level = levels[next]
		return next_level

func get_star_requirements(level_id):
	var level = levels_by_id.get(level_id)
	return level.get("stars")

var level_times_path = "user://level_times.save"
var user_progress_path = "user://user_progress.save"

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

func save_user_level_progress(player_name, level_no):
	var save_object = {}
	if FileAccess.file_exists(user_progress_path):
		var file = FileAccess.open(user_progress_path, FileAccess.READ)
		save_object = JSON.parse_string(file.get_as_text())
	
	var player_progress = save_object.get(player_name)
	if player_progress == null:
		player_progress = {}
	
	player_progress["level_progress"] = level_no
	
	save_object[player_name] = player_progress
	
	var file = FileAccess.open(user_progress_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_object))

func get_user_level_progress(player_name):
	if FileAccess.file_exists(user_progress_path):
		var file = FileAccess.open(user_progress_path, FileAccess.READ)
		var save_object = JSON.parse_string(file.get_as_text())
		var user_object = save_object.get(player_name)
		if user_object:
			var user_level_progress = user_object.get("level_progress")
			return user_level_progress
	
	return 0
