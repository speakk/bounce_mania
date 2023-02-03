@tool
extends Node2D

@export var size: float = 40:
	set(new_size):
		size = new_size
		queue_redraw()

var _current_color:
	set(new_color):
		_current_color = new_color
		queue_redraw()

@export var base_color := Color.REBECCA_PURPLE:
	set(new_color):
		base_color = new_color
		_current_color = base_color
		queue_redraw()

func _draw():
	draw_circle_arc_poly(Vector2(0, 0), size, 0, 360, _current_color)

func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()
	points_arc.push_back(center)
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		
	var uvs = PackedVector2Array()
	for point in points_arc:
		var uv = (Vector2(radius, radius) + point) / radius / 2
		uvs.push_back(uv)
		
	draw_polygon(points_arc, colors, uvs)
