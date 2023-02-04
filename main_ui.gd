extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.palette_changed.connect(_palette_changed)


func _palette_changed(new_palette, palette_index, palette_shift_index):
	$NotificationLabel.text = "Palette index: %s, shift: %s" % [palette_index, palette_shift_index]
