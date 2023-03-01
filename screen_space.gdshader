shader_type canvas_item;

uniform sampler2D vignette;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float amount = 1.0;

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	vec4 color2 = texture(screen_texture, SCREEN_UV);
	
	float vignette_value = texture(vignette, UV).r;
	
	color.r = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x*amount, 0.0) * vignette_value).r;
	color.g = texture(screen_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x*amount/2.0, 0.0) * vignette_value).g;
	color.b = texture(screen_texture, SCREEN_UV - vec2(SCREEN_PIXEL_SIZE.x*amount, 0.0) * vignette_value).b;
	color.a = 1.0;
	
	COLOR = color;
}
