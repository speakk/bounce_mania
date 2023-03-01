shader_type canvas_item;

uniform sampler2D texture2: repeat_enable;
uniform vec4 mod_color: source_color;
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec2 time;

void fragment() {
//	float color = texture(TEXTURE, offset + UV + time).r;
//	float color2 = texture(texture2, offset + UV - time).r;
	float color = texture(TEXTURE, offset + UV).r;
	float color2 = texture(texture2, offset + UV).r;
	float energy = color * color2;
	vec4 orig_color = vec4(COLOR);
	
	vec4 new_color = vec4(energy, energy, energy, 1);
	
	if (new_color.r > 0.5) {
		//COLOR = vec4(0.5);
		COLOR = vec4(orig_color.r, orig_color.g, orig_color.b, 0.0);
	} else {
		COLOR = mod_color;
	}
//	if (color.r > 0.5) {
//		//COLOR = vec4(0.5);
//		COLOR = vec4(orig_color.r, orig_color.g, orig_color.b, 0.0);
//	} else {
//		COLOR = vec4(orig_color.r, orig_color.g, orig_color.b, 0.2);
//	}
}
