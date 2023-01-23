extends Node

func _ready():
	Events.player_collision_happened.connect(_on_player_collision)

const volume_ceiling = 6
const pitch_variation = 0.06

func _on_player_collision(collison_speed):
	$CollisionStream.volume_db = min(-16 + log(collison_speed*0.001) * 2.5, volume_ceiling)
	$CollisionStream.pitch_scale = 1 + randf()*pitch_variation - pitch_variation/2
	$CollisionStream.play()
