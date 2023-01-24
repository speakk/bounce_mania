extends Control

var style_box = StyleBoxFlat.new()

var charging_color = "ffae00"
var dashing_color = "fff200"
var charge_ready_color = "9bd453"

var dash_timeout = GlobalValues.player_dash_charge_timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.bounce_timer_changed.connect(_bounce_timer_changed)
	Events.player_bounce_started.connect(_player_bounce_started)
	Events.player_bounce_ended.connect(_player_bounce_ended)
	Events.player_dash_charged.connect(_player_dash_charged)
	%PanelContainer.add_theme_stylebox_override("panel", style_box)
	style_box.bg_color = Color(charging_color)
	%BounceChargeProgressBar.max_value = dash_timeout

func _bounce_timer_changed(new_time):
	%BounceChargeProgressBar.value = dash_timeout - new_time

func _player_bounce_started():
	#%PanelContainer.theme_override_styles.panel.bgcolor = Color.RED
	#$VBoxContainer/PanelContainer.theme.add_theme_stylebox_override("bgcolor", Color.RED)
	style_box.bg_color = Color(dashing_color)

func _player_dash_charged():
	style_box.bg_color = Color(charge_ready_color)
	
func _player_bounce_ended():
	style_box.bg_color = Color(charging_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
