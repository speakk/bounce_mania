shader_type canvas_item;

uniform sampler2D texture2: repeat_enable;
uniform vec4 mod_color: source_color;
uniform vec4 mod_color2: source_color;
//uniform vec2 offset = vec2(0.0, 0.0);
uniform float speed = 0.02;
uniform float bias = 0.5;

void fragment() {
	float offset = texture(TEXTURE, UV - TIME * 0.1).r * 0.1;
//	float color = texture(TEXTURE, offset + UV + time).r;
//	float color2 = texture(texture2, offset + UV - time).r;
	float color = texture(TEXTURE, offset + UV + TIME * vec2(speed, speed)).r;
	float color2 = texture(texture2, offset + UV - TIME * vec2(speed, speed)).r;
	float energy = color * color2;
	vec4 orig_color = vec4(COLOR);
	
	vec4 new_color = vec4(energy, energy, energy, 1);
	
	COLOR = new_color * mod_color + mod_color2;
	
//	if (new_color.r > bias * abs(sin(TIME * 0.5)) * 0.5 + 0.25) {
//		//COLOR = vec4(0.5);
//		//COLOR = vec4(orig_color.r, orig_color.g, orig_color.b, 0.0);
//		COLOR = mod_color2;
//		COLOR.a = color;
//	} else {
//		COLOR = mod_color;
//	}
}
