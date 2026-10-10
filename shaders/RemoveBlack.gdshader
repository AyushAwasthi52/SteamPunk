shader_type canvas_item;

uniform float threshold = 0.1;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    
    // Remove black/dark backgrounds
    if (tex.r < threshold && tex.g < threshold && tex.b < threshold) {
        discard;
    }
    // Remove white/light backgrounds
    if (tex.r > 1.0 - threshold && tex.g > 1.0 - threshold && tex.b > 1.0 - threshold) {
        discard;
    }
    
    COLOR = tex;
}
