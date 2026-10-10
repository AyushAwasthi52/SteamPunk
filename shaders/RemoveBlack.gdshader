shader_type canvas_item;

uniform float threshold = 0.1;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    if (tex.r < threshold && tex.g < threshold && tex.b < threshold) {
        discard;
    }
    COLOR = tex;
}
