shader_type canvas_item;

uniform sampler2D texture2: repeat_enable;
uniform sampler2D extra_texture;
uniform vec4 mod_color: source_color;
uniform vec4 mod_color2: source_color;
uniform vec2 offset2 = vec2(0.0, 0.0);
uniform float speed = 0.015;
uniform float speed2 = 0.005;
uniform float bias = 0.5;

void fragment() {
	float offset = texture(TEXTURE, UV - TIME * speed2).r * 0.1;
//	float color = texture(TEXTURE, offset + UV + time).r;
//	float color2 = texture(texture2, offset + UV - time).r;
	float color = texture(TEXTURE, offset + UV + TIME * vec2(speed, speed)).r;
	float color2 = texture(texture2, offset + UV - TIME * vec2(speed, speed)).r;
	float energy = color * color2;
	vec4 orig_color = vec4(COLOR);
	
	vec4 new_color = vec4(energy, energy, energy, 1);
	
	//vec4 cool_fx = vec4((new_color * mod_color + mod_color2).rgb, 0.2);
	vec4 cool_fx = new_color * mod_color + mod_color2;
	vec4 extra_texture_color = texture(extra_texture, UV * 0.6 - offset2 * 0.1 + offset * 0.1);
	
	COLOR = extra_texture_color * 0.35 + cool_fx * 0.3;
	
//	if (new_color.r > bias * abs(sin(TIME * 0.5)) * 0.5 + 0.25) {
//		//COLOR = vec4(0.5);
//		//COLOR = vec4(orig_color.r, orig_color.g, orig_color.b, 0.0);
//		COLOR = mod_color2;
//		COLOR.a = color;
//	} else {
//		COLOR = mod_color;
//	}
}
