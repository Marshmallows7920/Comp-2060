shader_type canvas_item;

uniform float custom_time = 1.0;
uniform vec4 red = vec4(1.0,0,0,1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 default_color = texture(TEXTURE, UV);
	COLOR = mix(red, default_color, custom_time)*default_color.a;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
