extends Node

const levels = [
	{
		name = "Level 1",
		id = "level_1",
		path = "res://levels/level_1.tscn"
	}
]

var levels_by_id = {}

func _ready():
	for level in levels:
		levels_by_id[level.id] = level

func get_by_id(id):
	return levels_by_id.get(id)
