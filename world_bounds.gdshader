shader_type canvas_item;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec4 orig_color = vec4(COLOR);
	
	if (color.r > 0.5) {
		//COLOR = vec4(0.5);
		COLOR = vec4(orig_color.r, orig_color.g, orig_color.b, 0.0);
	} else {
		COLOR = vec4(orig_color.r, orig_color.g, orig_color.b, 0.2);
	}
}
