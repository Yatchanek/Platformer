shader_type canvas_item;

uniform vec4 target_color : source_color;
uniform bool is_attacking = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if (color.a > 0.0) {
		if (is_attacking) {
			if (color.r == color.g && color.g == color.b && color.r > 0.8	) {
				color = target_color;
				COLOR = color;
			}
		}		
	}	
}

