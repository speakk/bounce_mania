extends Node

signal brick_hit(brick, by, damage)

signal end_zone_hit(end_zone, by)

signal level_timer_changed(new_time)
signal bounce_timer_changed(new_time)
signal all_tokens_collected()
signal token_collected(token)

signal player_has_moved
signal player_collision_happened(collision_speed)
signal player_bounce_started
signal player_bounce_ended
signal player_dash_charged
signal player_dash_charge_time_changed(value)

signal new_game_pressed
signal try_again_pressed
signal level_change_pressed(level_id)
signal next_level_pressed
signal profile_manager_pressed
signal main_menu_pressed
signal first_time_player_added(player_id)

signal level_loaded(level_id)
signal level_finished(level_id, time)
signal in_game_paused
signal in_game_resumed

signal in_game_entered
signal in_game_exited

signal main_menu_entered


signal player_list_changed(new_list)
signal current_profile_changed(new_player)

# DEBUG SIGNALS:
signal palette_changed(new_palette, palette_index, palette_shift_index)
