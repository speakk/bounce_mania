extends Node

@onready
var THEME = preload("res://main_theme.tres")

const palettes = [
	["d4f2db","cef7a0","ba9790","914d76","69353f"],
	["ed254e","f9dc5c","c2eabd","011936","465362"],
	["001b2e","294c60","adb6c4","ffefd3","ffc49b"],
	["eca400","eaf8bf","006992","27476e","001d4a"],
	["33658a","86bbd8","758e4f","f6ae2d","f26419"],
	["c2b2b4","6b4e71","3a4454","53687e","f5dddd"],
	["8d6a9f","c5cbd3","8cbcb9","dda448","bb342f"],
	["e4fde1","8acb88","648381","575761","ffbf46"],
	["1a1423","3d314a","684756","96705b","ab8476"],
	["3d315b","444b6e","708b75","9ab87a","f8f991"]
]

var accent_a = Color("#C14953")
var accent_b = Color("#E5DCC5")
var background_a = Color("#2D2D2A")
var background_b = Color("#4C4C47")
var neutral_a = Color("#848FA5")

func set_ui_colors():
	var colors = get_current_palette()
	
	THEME.get_stylebox("panel", "Panel").bg_color = colors.background_a
	THEME.get_stylebox("panel", "PanelContainer").bg_color = colors.background_a
	THEME.get_stylebox("scroll", "VScrollBar").bg_color = colors.background_b
	
	# BUTTONS START
	var button_stylebox = THEME.get_stylebox("normal", "Button")
	button_stylebox.bg_color = colors.background_b
	button_stylebox.border_color = colors.background_b.darkened(0.4)
	
	var hover_stylebox = button_stylebox.duplicate(true)
	hover_stylebox.bg_color = colors.background_b.lightened(0.4)
	hover_stylebox.bg_color.s += 0.3
	THEME.set_stylebox("hover", "Button", hover_stylebox)
	
	var pressed_stylebox = button_stylebox.duplicate(true)
	pressed_stylebox.bg_color = colors.background_b.darkened(0.4)
	#pressed_stylebox.bg_color.s += 0.3
	THEME.set_stylebox("pressed", "Button", pressed_stylebox)
	# BUTTONS END

func _ready():
	var palette = palettes[current_palette_index].duplicate(true)
	emit_new_palette()


func shift_array(array: Array, amount: int):
	for i in range(amount):
		var element = array.pop_front()
		array.push_back(element)

var current_palette_index = 5
var current_palette_shift = 3

func emit_new_palette():
	var new_colors = get_current_palette()
	set_ui_colors()
	Events.palette_changed.emit(new_colors, current_palette_index, current_palette_shift)

func shift_palette_index():
	current_palette_index += 1
	current_palette_index = wrapi(current_palette_index, 0, palettes.size())
	current_palette_shift = 0
	emit_new_palette()

func shift_current_palette():
	current_palette_shift += 1
	current_palette_shift = wrapi(current_palette_shift, 0, palettes[current_palette_index].size())
	emit_new_palette()

func get_current_palette():
	var palette = palettes[current_palette_index].duplicate(true)
	shift_array(palette, current_palette_shift)
	
	var new_colors = {
		accent_a = Color(palette[0]),
		accent_b = Color(palette[1]),
		background_a = Color(palette[2]),
		background_b = Color(palette[3]),
		neutral_a = Color(palette[4]),
	}
	
	new_colors.background_a.v = minf(new_colors.background_a.v, 0.4)
	new_colors.background_b.v = minf(new_colors.background_b.v, 0.4)
	
	return new_colors
	
func _process(_delta):
	if Input.is_action_just_pressed("shift_palette_index"):
		shift_palette_index()
	
	if Input.is_action_just_pressed("shift_palette"):
		shift_current_palette()
