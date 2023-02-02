extends Node2D

func _ready():
	get_node("PlayerMarker").visible = false
	$TextureRect.modulate = Colors.background_a

func get_player_start_position():
	return get_node("PlayerMarker").position
