shader_type canvas_item;

uniform float threshold : hint_range(0.0, 0.6	, 0.01);
const float ratio = 360.0 / 640.0;

void fragment() {
	vec2 scaled_uv = vec2(UV.x, UV.y * ratio);
	vec2 middle = vec2(0.5, 0.5 * ratio);
	//vec4 color = texture(TEXTURE, UV);
	if (distance(middle, scaled_uv) < threshold) {
//	if (distance(middle.x, UV.x) < threshold && distance(middle.y, UV.y) < threshold ) {
		COLOR.a = 0.0;
	}

}
