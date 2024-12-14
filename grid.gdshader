shader_type spatial;
render_mode blend_mix, unshaded;

uniform float grid_size = 1.0;
uniform float line_thickness = 0.01;
uniform vec2 origin_offset = vec2(0.0, 0.0);
uniform vec4 color: source_color = vec4(0.0, 0.3, 0.0, 0.5);

varying vec2 point_world;

void vertex(){
	point_world = (MODEL_MATRIX * vec4(VERTEX, 1.0) ).xz - origin_offset;
}

void fragment() {
	float thick = line_thickness / grid_size;
	vec2 df = fract(point_world / grid_size + thick / 2.0);
	float grid = step(thick, df.x) * step(thick, df.y);
	ALBEDO = color.rgb;
	ALPHA = (1.0 - grid) * color.a;
}