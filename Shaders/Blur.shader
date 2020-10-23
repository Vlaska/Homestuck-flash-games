shader_type canvas_item;
render_mode unshaded;


uniform int box_radius: hint_range(0, 255) = 10;


void fragment() {
	highp vec4 color = vec4(0.0);
	highp float wsum = 0.0;
	highp float w = 1.0;

	for (int j = -box_radius; j <= box_radius; ++j) {
		float y = (UV.y + float(j) / 450.0);
		for (int i = -box_radius; i <= box_radius; ++i) {
			vec2 pos = vec2((UV.x + float(i) / 650.0), y);
			color += texture(TEXTURE, pos) * w;
		}
	}
	int t = box_radius * 2 + 1;
	int p = t * t;
	COLOR = color / float(p);
}
