shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(1.0);
uniform vec4 outline_color : source_color = vec4(0.3, 0.8, 0.9, 1.0); // Cyan blueprint outline
uniform float outline_width = 0.05;

void fragment() {
    vec2 uv = UV;
    
    // Check if we are near the edge
    float edge_x = max(step(uv.x, outline_width), step(1.0 - outline_width, uv.x));
    float edge_y = max(step(uv.y, outline_width), step(1.0 - outline_width, uv.y));
    
    vec4 final_color = base_color;
    
    // Add a slight metallic/brass gradient based on Y position
    final_color.rgb *= mix(0.7, 1.3, uv.y);
    
    if (edge_x > 0.0 || edge_y > 0.0) {
        final_color = outline_color;
    }
    
    COLOR = final_color;
}
