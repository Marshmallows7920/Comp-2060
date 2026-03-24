shader_type canvas_item;

uniform float cooldown = 0.5;
uniform float max_cooldown = 1;
uniform vec4 cooldown_overlay = vec4(0,0,0,0.5);
uniform vec4 clear = vec4(1.0,1.0,1.0,0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float fraction = cooldown / max_cooldown;
	float new_y_uv = floor(UV.y + fraction);
	vec4 weights = vec4(new_y_uv);
	COLOR = mix(clear, cooldown_overlay, weights);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
