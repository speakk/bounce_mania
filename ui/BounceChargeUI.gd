extends Control

var style_box = StyleBoxFlat.new()

var charging_color = "ffae00"
var dashing_color = "fff200"
var charge_ready_color = "9bd453"

var dash_timeout = GlobalValues.player_dash_charge_timeout
var current_bounce_time = dash_timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.bounce_timer_changed.connect(_bounce_timer_changed)
	Events.player_bounce_started.connect(_player_bounce_started)
	Events.player_bounce_ended.connect(_player_bounce_ended)
	Events.player_dash_charged.connect(_player_dash_charged)
	var empty_style = StyleBoxEmpty.new()
	#%PanelContainer.add_theme_stylebox_override("panel", style_box)
	%PanelContainer.add_theme_stylebox_override("panel", empty_style)
	style_box.bg_color = Color(charging_color)
	%BounceChargeProgressBar.max_value = dash_timeout

func _bounce_timer_changed(new_time):
	current_bounce_time = new_time
	#%BounceChargeProgressBar.value = lerpf(%BounceChargeProgressBar.value, dash_timeout - new_time, 0.5)

func _player_bounce_started():
	style_box.bg_color = Color(dashing_color)
	%BounceChargeProgressBar.tint_progress = Color.WHITE
	$VBoxContainer/Label.show()
	$VBoxContainer/Label2.hide()

func _player_dash_charged():
	style_box.bg_color = Color(charge_ready_color)
	%BounceChargeProgressBar.tint_progress = Color.YELLOW
	$VBoxContainer/Label2.show()
	$VBoxContainer/Label.hide()
	
func _player_bounce_ended():
	style_box.bg_color = Color(charging_color)
	%BounceChargeProgressBar.tint_progress = Color.WHITE
	$VBoxContainer/Label.show()
	$VBoxContainer/Label2.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		%BounceChargeProgressBar.value = lerpf(%BounceChargeProgressBar.value, dash_timeout - current_bounce_time, 0.1)
