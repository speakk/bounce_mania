extends Node

const IN_GAME_PATH = "res://in_game.tscn"

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _switch_scene(scene_path):
	var previous_scene = $Scenes.get_child(0)
	var new_scene = load(scene_path).instantiate()
	if previous_scene:
		if "disable_main_camera" in previous_scene:
			previous_scene.disable_main_camera()
		previous_scene.queue_free()
	$Scenes.add_child(new_scene)
	
	if "enable_main_camera" in new_scene:
		new_scene.enable_main_camera()
	

func _ready():
	Events.new_game_pressed.connect(_new_game_pressed)

func _new_game_pressed():
	_switch_scene(IN_GAME_PATH)
