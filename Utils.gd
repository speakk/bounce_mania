extends Node

func get_time_label(time: float):
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100
	
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	return time_string

static func set_canvas_item_light_mask_value(canvas_item: CanvasItem, layer_number: int, value: bool) -> void:
	assert(layer_number >= 1 and layer_number <= 20, "layer_number must be between 1 and 20 inclusive")
	if value:
		canvas_item.light_mask |= 1 << (layer_number - 1)
	else:
		canvas_item.light_mask &= ~(1 << (layer_number - 1))

static func get_canvas_item_light_mask_value(canvas_item: CanvasItem, layer_number: int) -> bool:
	assert(layer_number >= 1 and layer_number <= 20, "layer_number must be between 1 and 20 inclusive")
	return bool(canvas_item.light_mask & (1 << (layer_number - 1)))

static func set_canvas_item_light_occluder_mask_value(canvas_item: CanvasItem, layer_number: int, value: bool) -> void:
	assert(layer_number >= 1 and layer_number <= 20, "layer_number must be between 1 and 20 inclusive")
	if value:
		canvas_item.occluder_light_mask |= 1 << (layer_number - 1)
	else:
		canvas_item.occluder_light_mask &= ~(1 << (layer_number - 1))
