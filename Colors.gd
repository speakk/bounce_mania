extends Node

# 01 ##
#const accent_a = Color("#E94F37")
#const accent_b = Color("#FFFC31")
#const background_b = Color("#5C415D")
#const background_a = Color("#393E41")
#const neutral_a = Color("#F6F7EB")

## 02
#const accent_a = Color("#BFD1E5")
#const accent_b = Color("#D8BFAA")
#const background_b = Color("#542344")
#const background_a = Color("#808080")
#const neutral_a = Color("#EBF5EE")

# 03
#const accent_a = Color("#F7ACCF")
#const accent_b = Color("#6874E8")
#const background_a = Color("#7A5C61")
#const background_b = Color("#392759")
#const neutral_a = Color("#E8F0FF")

# 04
#const accent_a = Color("#92140C")
#const accent_b = Color("#FFCF99")
#const background_a = Color("#1E1E24")
#const background_b = Color("#111D4A")
#const neutral_a = Color("#FFF8F0")

## 05
#const accent_a = Color("#C14953")
#const accent_b = Color("#E5DCC5")
#const background_a = Color("#2D2D2A")
#const background_b = Color("#4C4C47")
#const neutral_a = Color("#848FA5")

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

func shift_array(array: Array, amount: int):
	for i in range(amount):
		var element = array.pop_front()
		array.push_back(element)

var current_palette_index = 0
var current_palette_shift = 0

func emit_new_palette():
	var new_colors = get_current_palette()
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
	
func _ready():
	var palette = palettes[current_palette_index].duplicate(true)
	emit_new_palette()

func _process(_delta):
	if Input.is_action_just_pressed("shift_palette_index"):
		shift_palette_index()
	
	if Input.is_action_just_pressed("shift_palette"):
		shift_current_palette()
