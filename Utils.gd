extends Node

func get_time_label(time: float):
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100
	
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	return time_string
