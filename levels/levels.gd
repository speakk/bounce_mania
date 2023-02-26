extends Node

const levels = [
	{
		name = "Level 1",
		id = "level_1",
		path = "res://levels/level_1.tscn",
		stars = [4.5, 3, 2.2],
		title = "The Beginning",
		description = "wasd to move.\nRight click to dash when the dash meter is full!\nMake it to the end as quickly as you can!"
	},
	{
		name = "Level 2",
		id = "level_2",
		path = "res://levels/level_2.tscn",
		stars = [4.5, 4, 3],
		title = "Quick Corners",
		description = "Protip: Press r to quick restart the level if you mess up"
	},
	{
		name = "Level 3",
		id = "level_3",
		path = "res://levels/level_3.tscn",
		stars = [5.5, 5, 3],
		title = "Token Pits",
		description = "Collect the round tokens to open the door"
	},
	{
		name = "Level 4",
		id = "level_4",
		path = "res://levels/level_4.tscn",
		stars = [7, 6, 5.5],
		title = "Easy Diagonals"
	},
	{
		name = "Level 5",
		id = "level_5",
		path = "res://levels/level_5.tscn",
		stars = [7, 6.5, 6],
		title = "Back and Forth"
	},
	{
		name = "Level 6",
		id = "level_6",
		path = "res://levels/level_6.tscn",
		stars = [7, 6.5, 6],
		title = "The Cave"
	},
	{
		name = "Level 7",
		id = "level_7",
		path = "res://levels/level_7.tscn",
		stars = [7, 6.5, 6],
		title = "Moves"
	},
	{
		name = "Level 8",
		id = "level_8",
		path = "res://levels/level_8.tscn",
		stars = [15, 10, 12],
		title = "Grave"
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

