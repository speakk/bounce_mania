@tool
extends Node2D

class_name Circle

var _polygon

@export var size: float = 40:
	set(new_size):
		size = new_size
		update_polygon()
		queue_redraw()

var _current_color:
	set(new_color):
		_current_color = new_color
		queue_redraw()

@export var color := Color.REBECCA_PURPLE:
	set(new_color):
		color = new_color
		_current_color = color
		queue_redraw()

func update_polygon():
	var nb_points = 32
	var center = Vector2(0, 0)
	var angle_from = 0
	var angle_to = 360
	var radius = size
	
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	_polygon = points_arc

func _draw():
	draw_circle_arc_poly(_current_color)

func draw_circle_arc_poly(color):
	var uvs = PackedVector2Array()
	var radius = size
	for point in _polygon:
		var uv = (Vector2(radius, radius) + point) / radius / 2
		uvs.push_back(uv)
	
	var colors = PackedColorArray([color])
	draw_polygon(_polygon, colors, uvs)
