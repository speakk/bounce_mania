extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.palette_changed.connect(_palette_changed)
	Events.level_loaded.connect(_level_loaded)

func _palette_changed(new_palette, palette_index, palette_shift_index):
	$NotificationLabel.text = "Palette index: %s, shift: %s" % [palette_index, palette_shift_index]

func _level_loaded(level_id):
	$LevelTimerBarUI.set_level_times(Levels.get_by_id(level_id).stars)
