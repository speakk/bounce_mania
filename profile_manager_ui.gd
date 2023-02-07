extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_to_main_menu_pressed():
	Events.main_menu_pressed.emit()
