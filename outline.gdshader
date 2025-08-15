shader_type spatial;
render_mode cull_front, unshaded;

uniform float outline_width = 5.0;
uniform float outline_onoff = 0.0;
uniform float outline_brightness = 1.0;


const vec3 dark_red = vec3(0.0, 0.0, 0.0);
const vec3 bright_red = vec3(1.0, 0.0, 0.0);

void vertex() {
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);

	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;

	clip_position.xy += offset;

	POSITION = clip_position;
}

void fragment() {
	if (outline_onoff > 0.5) {
		vec3 color = mix(dark_red, bright_red, outline_brightness);
		ALBEDO = color;

		ALPHA = 1.0;
	}
	else {
		discard;
	}
}
