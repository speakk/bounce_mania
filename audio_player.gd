extends Node

# TODO:
# Just stop other players when another scene starts playing music.
# Probably no reason to stop it in an _on_exit type event?

func _ready():
	Events.player_collision_happened.connect(_on_player_collision)
	Events.in_game_entered.connect(_on_in_game_entered)
	Events.main_menu_entered.connect(_on_main_menu_entered)
	Events.player_bounce_started.connect(_on_player_bounce_started)
	Events.bounce_timer_changed.connect(_on_bounce_timer_changed)
	Events.level_finished.connect(_on_level_finished)
	Events.token_collected.connect(_on_token_collected)
	Events.player_died.connect(_on_player_died)
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().node_added.connect(_on_SceneTree_node_added)
	#Events.in_game_exited.connect(_on_in_game_exited)


const volume_ceiling = -4
const pitch_variation = 0.06

var should_play_in_game_music := false

var songs_length = 2

@onready var song_players = [$InGameMusicPlayer, $InGameMusicPlayer2]
var current_song_player_index = 1

func get_current_in_game_music_player():
	return song_players[current_song_player_index]
	
func _process(_delta):
	if should_play_in_game_music:
		var current_player = song_players[current_song_player_index]
		if not current_player.playing:
			print("Playing next")
			var next_index = wrapi(current_song_player_index + 1, 0, song_players.size())
			print("Next index", next_index)
			var next_player = song_players[next_index]
			current_song_player_index = next_index
			next_player.play()
			
func _on_player_died():
	$ExplosionStream.play()

func _on_token_collected(_a):
	$TokenCollectStream.play()

func _on_main_menu_entered():
	if get_current_in_game_music_player().playing:
		get_current_in_game_music_player().stop()
		should_play_in_game_music = false
	
	if not $MainMaenuStream.playing:
		$MainMaenuStream.play()

func _on_in_game_entered():
	if $MainMaenuStream.playing:
		$MainMaenuStream.stop()
	
	should_play_in_game_music = true
#	if not get_current_in_game_music_player().playing:
#		get_current_in_game_music_player().play()

#func _on_in_game_exited():
	#if $InGameMusicPlayer.playing:
	#	$InGameMusicPlayer.stop()

var last_collision_time = 0.0
var grind_treshold = 38 # ms

func _on_player_collision(collison_speed):
	if collison_speed > 600:
		var volume = min(-70 + log(collison_speed*0.001) * 9.5, volume_ceiling)
		$CollisionStream.volume_db = volume
		$CollisionStream.pitch_scale = 1 + randf()*pitch_variation - pitch_variation/2 - 0.1

		if Time.get_ticks_msec() - last_collision_time < grind_treshold:
			$GrindStream.volume_db = volume
			$GrindStream.play()
		else:
			$CollisionStream.play()

		last_collision_time = Time.get_ticks_msec()

func _on_player_bounce_started():
	$DashStream.play()

func _on_bounce_timer_changed(value):
	var dash_timeout = GlobalValues.player_dash_charge_timeout
	if value > 0 and value < dash_timeout:
		$DashChargeStream.pitch_scale = 0.5 + (1 - (value / dash_timeout)) * 0.5
		var previousPosition = $DashChargeStream.get_playback_position()
		$DashChargeStream.play()
		$DashChargeStream.seek(maxf(0, previousPosition - 0.5))

func _on_level_finished(level_id, time):
	var star_level = Levels.get_star_level_reached(level_id, time)
	if star_level == 2:
		$LevelFinishedGoldStarStream.play()
	elif star_level != null:
		$LevelFinishedStarsStream.play()
	else:
		$LevelFinishedNoStarsStream.play()

func _on_SceneTree_node_added(node):
	if node is Button:
		connect_to_button(node)

func _on_Button_pressed():
	$ButtonClickStream.play()

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button):
	button.pressed.connect(_on_Button_pressed)
