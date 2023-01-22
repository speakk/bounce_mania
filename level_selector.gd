extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for level in Levels.levels:
		var button = Button.new()
		button.text = level.name
		button.pressed.connect(_change_level.bind(level.id))
		button.custom_minimum_size.x = 160
		button.custom_minimum_size.y = 60
		%LevelList.add_child(button)

func _change_level(level_id):
	Events.level_change_pressed.emit(level_id)
