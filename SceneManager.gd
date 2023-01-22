extends Node

const IN_GAME_PATH = "res://in_game.tscn"
const LEVEL_SELECTOR_PATH = "res://level_selector.tscn"


func _ready():
	Events.new_game_pressed.connect(_new_game_pressed)
	Events.try_again_pressed.connect(_try_again_pressed)
	Events.level_change_pressed.connect(_level_change_pressed)

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _switch_scene(scene_path, level_id):
	var previous_scene = $Scenes.get_child(0)
	var new_scene = load(scene_path).instantiate()
	if previous_scene:
		if "disable_main_camera" in previous_scene:
			previous_scene.disable_main_camera()

		previous_scene.queue_free()
	$Scenes.add_child(new_scene)
	
	# TODO: Just add special handling in general for in_game?
	# As in don't just use "enable_main_camera" to detect it
	if "enable_main_camera" in new_scene:
		new_scene.load_level(level_id)
	
	# Reset "camera" as in viewport location just in case
	# the scene we just switched to doesn't have a camera
	var viewport = get_viewport()
	viewport.canvas_transform = Transform2D.IDENTITY

func _new_game_pressed():
	_switch_scene(LEVEL_SELECTOR_PATH, null)
	
func _try_again_pressed():
	_switch_scene(IN_GAME_PATH, $Scenes.get_child(0).get_current_level_id())

func _level_change_pressed(level_id):
	_switch_scene(IN_GAME_PATH, level_id)
