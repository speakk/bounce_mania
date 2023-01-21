extends Control

const levels = [
	{
		name = "Level 1",
		path = "res://levels/level1.tscn"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for level in levels:
		var button = Button.new()
		button.text = level.name
		button.pressed.connect(_change_level.bind(level.path))
		%LevelList.add_child(button)

func _change_level(level_path):
	Events.level_change_pressed.emit(level_path)
