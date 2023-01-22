extends Node2D

const Player = preload("res://player.tscn")

var level_timer = 0
var paused = false
var finished = false
var current_level_path = null
var player_node = null
var camera_node = null

var player_has_moved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.end_zone_hit.connect(_on_end_zone_hit)
	Events.player_has_moved.connect(_on_player_has_moved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not paused and player_has_moved:
		level_timer += delta
		Events.level_timer_changed.emit(level_timer)

func _on_player_has_moved():
	player_has_moved = true
	%HasMovedLabel.visible = false
	

func load_level(level_path):
	if $LevelContainer.get_child_count() > 0:
		$LevelContainer.get_child(0).queue_free()
	
	$LevelContainer.add_child(load(level_path).instantiate())
	current_level_path = level_path
	
	var player = Player.instantiate()
	var start_position = $LevelContainer.get_child(0).get_player_start_position()
	player.global_position = start_position
	add_child(player)
	player_node = player
	
	var camera = Camera2D.new()
	camera.current = true
	player.add_child(camera)
	camera_node = camera

func get_current_level_path():
	return current_level_path

func _finish_level():
	paused = true
	finished = true
	Events.level_finished.emit(level_timer)
	%FinishedScreen.show()

func _on_end_zone_hit(zone, by):
	if "is_player" in by and by.is_player and not finished:
		_finish_level()


func disable_main_camera():
	camera_node.current = false

func enable_main_camera():
	camera_node.current = true
