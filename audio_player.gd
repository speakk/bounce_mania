extends Node

# TODO:
# Just stop other players when another scene starts playing music.
# Probably no reason to stop it in an _on_exit type event?

func _ready():
	Events.player_collision_happened.connect(_on_player_collision)
	Events.in_game_entered.connect(_on_in_game_entered)
	Events.main_menu_entered.connect(_on_main_menu_entered)
	#Events.in_game_exited.connect(_on_in_game_exited)

const volume_ceiling = 6
const pitch_variation = 0.06

func _on_main_menu_entered():
	if $InGameMusicPlayer.playing:
		$InGameMusicPlayer.stop()
	
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
