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

