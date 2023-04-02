extends PanelContainer

var style_box = StyleBoxFlat.new()

var charging_color = "ff33ae"
var dashing_color = "fff200"
var charge_ready_color = "9bd453"

var current_charge = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.slow_power_amount_changed.connect(_slow_power_amount_changed)
	var empty_style = StyleBoxEmpty.new()
	#%PanelContainer.add_theme_stylebox_override("panel", style_box)
	%PanelContainer.add_theme_stylebox_override("panel", empty_style)
	style_box.bg_color = Color(charging_color)
	%SlowDownProgressBar.max_value = 1.0

func _slow_power_amount_changed(new_time):
	current_charge = new_time
	#%BounceChargeProgressBar.value = lerpf(%BounceChargeProgressBar.value, dash_timeout - new_time, 0.5)

#func _player_bounce_started():
#	style_box.bg_color = Color(dashing_color)
#	%BounceChargeProgressBar.tint_progress = Color.WHITE
#	$VBoxContainer/Label.show()
#	$VBoxContainer/Label2.hide()
#
#func _player_dash_charged():
#	style_box.bg_color = Color(charge_ready_color)
#	%BounceChargeProgressBar.tint_progress = Color.YELLOW
#	$VBoxContainer/Label2.show()
#	$VBoxContainer/Label.hide()
#
#func _player_bounce_ended():
#	style_box.bg_color = Color(charging_color)
#	%BounceChargeProgressBar.tint_progress = Color.WHITE
#	$VBoxContainer/Label.show()
#	$VBoxContainer/Label2.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		%SlowDownProgressBar.value = lerpf(%SlowDownProgressBar.value, current_charge, 0.1)
