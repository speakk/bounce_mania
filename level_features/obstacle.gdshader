shader_type canvas_item;
render_mode blend_premul_alpha,unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0, 5);

uniform vec4 mod_color : source_color = vec4(1.0,1.0,1.0,1.0);
uniform vec4 border_color : source_color = vec4(0.5,1.0,1.0,1.0);
uniform float border_width : hint_range(0.0, 1.0) = 0.9;

void fragment() { 
    vec4 blurcolor = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount); 
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	if (color.a > 0.0) {
		if (blurcolor.a < border_width) {
			COLOR = border_color;
		} else {
			COLOR = color;
		}
	} else {
		COLOR = blurcolor * vec4(mod_color.rgb, blurcolor.a);
	}
}

//shader_type canvas_item;
//
//uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//uniform float blur_amount : hint_range(0, 5);
//
//void fragment() {
//	vec4 texture_color = texture(TEXTURE, UV);
//	vec4 blurred_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
//	vec4 regular_color = texture(SCREEN_TEXTURE, SCREEN_UV);
//
//	if (texture_color.a == 0.0) {
//		COLOR = blurred_color;
//	} else {
//		COLOR = regular_color;
//	}
//
//}
