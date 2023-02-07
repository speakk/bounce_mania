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
	#Events.in_game_exited.connect(_on_in_game_exited)

const volume_ceiling = 6
const pitch_variation = 0.06

func _on_main_menu_entered():
	if $InGameMusicPlayer.playing:
		$InGameMusicPlayer.stop()
	
	if not $MainMaenuStream.playing:
		$MainMaenuStream.play()

func _on_in_game_entered():
	if $MainMaenuStream.playing:
		$MainMaenuStream.stop()
		
	if not $InGameMusicPlayer.playing:
		$InGameMusicPlayer.play()

#func _on_in_game_exited():
	#if $InGameMusicPlayer.playing:
	#	$InGameMusicPlayer.stop()

func _on_player_collision(collison_speed):
	$CollisionStream.volume_db = min(-10 + log(collison_speed*0.001) * 2.5, volume_ceiling)
	$CollisionStream.pitch_scale = 1 + randf()*pitch_variation - pitch_variation/2
	$CollisionStream.play()

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
