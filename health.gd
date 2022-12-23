extends Node2D

var _health = 20

signal health_zero
signal health_changed(current_value)

func take_damage(amount):
	_health -= amount
	emit_signal("health_changed", _health)
	if _health <= 0:
		emit_signal("health_zero")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
