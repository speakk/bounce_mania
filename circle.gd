@tool
extends Node2D

@export var size: float = 40:
	set(new_size):
		size = new_size
@export var color := Color.REBECCA_PURPLE

func _draw():
	draw_circle(Vector2.ZERO, size, color)
