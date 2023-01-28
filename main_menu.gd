extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.main_menu_entered.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_button_pressed():
	Events.new_game_pressed.emit()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_manage_profiles_button_pressed():
	Events.profile_manager_pressed.emit()
