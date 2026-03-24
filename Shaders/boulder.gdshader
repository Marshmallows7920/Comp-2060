shader_type canvas_item;

uniform vec2 pos = vec2(1,1);
uniform vec4 light_brown = vec4(0.259, 0.2, 0.133, 1.0);
uniform vec4 dark_brown = vec4(0.11, 0.078, 0.043, 1.0);
uniform sampler2D noise_texture : hint_default_white, repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 default_color = texture(TEXTURE,UV);
	vec2 tex_uv = mod(UV - (SCREEN_UV / (SCREEN_PIXEL_SIZE / SCREEN_PIXEL_SIZE.x)), 1.0);
	vec4 noise = texture(noise_texture, tex_uv);
	COLOR = mix(light_brown, dark_brown, noise)*default_color.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
