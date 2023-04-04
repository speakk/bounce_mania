extends Node

const levels = [
	{
		id = "level_1",
		path = "res://levels/level_1.tscn",
		stars = [5.5, 2.5, 2.4],
		title = "The Beginning",
		description = "a & d to move left/right.\nRight click to dash when the dash meter is full!\n"
	},
	{
		id = "level_2",
		path = "res://levels/level_2.tscn",
		stars = [5, 3.5, 2.8],
		title = "Quick Corners",
		description = "Protip: Press r to quick restart the level if you mess up"
	},
	{
		id = "level_3",
		path = "res://levels/level_3.tscn",
		stars = [8, 6, 4.8],
		title = "Token Pits",
		description = "Collect the round tokens to open the door"
	},
	{
		id = "level_4",
		path = "res://levels/level_4.tscn",
		stars = [11, 9, 7.2],
		title = "The Climb",
		description = "Hug walls to recharge your dash faster"
	},
	{
		id = "level_5",
		path = "res://levels/level_5.tscn",
		stars = [7, 5.5, 4.4],
		title = "Back and Forth"
	},
	{
		id = "level_6",
		path = "res://levels/level_6.tscn",
		stars = [9, 6.5, 5.1],
		title = "The Cave",
		description = "The darker walls don't bounce!"
	},
	{
		id = "level_7",
		path = "res://levels/level_7.tscn",
		stars = [8, 6.5, 5.3],
		title = "Moves"
	},
	{
		id = "level_8",
		path = "res://levels/level_8.tscn",
		stars = [17, 10, 9.5],
		title = "Grave"
	},
	{
		id = "level_9",
		path = "res://levels/level_9.tscn",
		stars = [11.5, 9, 8.15],
		title = "Up and Down"
	},
	{
		id = "level_10",
		path = "res://levels/level_10.tscn",
		stars = [12, 9.5, 8.6],
		title = "Up and Away"
	},
	{
		id = "level_11",
		path = "res://levels/level_11.tscn",
		stars = [15, 12.5, 11.5],
		title = "It Gets Tough"
	},
	{
		id = "level_12",
		path = "res://levels/level_12.tscn",
		stars = [28, 26, 25],
		title = "Long Haul"
	},
	{
		id = "level_13",
		path = "res://levels/level_13.tscn",
		stars = [25, 23, 20.5],
		title = "Return To Sender"
	},
	{
		id = "level_14",
		path = "res://levels/level_14.tscn",
		stars = [23, 20, 18],
		title = "Medium Peaks"
	},
	{
		id = "level_15",
		path = "res://levels/level_15.tscn",
		stars = [12, 11, 9.9],
		title = "Precision"
	}
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

