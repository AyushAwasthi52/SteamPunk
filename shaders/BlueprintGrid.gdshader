shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.04, 0.12, 0.28, 1.0);
uniform vec4 grid_color : source_color = vec4(0.2, 0.65, 0.9, 1.0);
uniform float grid_scale = 40.0;
uniform float line_thickness = 0.02;

void fragment() {
    vec2 uv = UV * grid_scale;
    vec2 grid = fract(uv);
    
    // Major grid lines
    float line_x = step(grid.x, line_thickness);
    float line_y = step(grid.y, line_thickness);
    
    // Minor grid lines (5 subdivisions per major block)
    vec2 minor_uv = UV * (grid_scale * 5.0);
    vec2 minor_grid = fract(minor_uv);
    float minor_x = step(minor_grid.x, line_thickness * 0.5);
    float minor_y = step(minor_grid.y, line_thickness * 0.5);
    
    vec4 final_color = bg_color;
    
    // Apply minor grid with low opacity
    if (minor_x > 0.0 || minor_y > 0.0) {
        final_color = mix(bg_color, grid_color, 0.15);
    }
    
    // Apply major grid with higher opacity
    if (line_x > 0.0 || line_y > 0.0) {
        final_color = mix(bg_color, grid_color, 0.5);
    }
    
    // Slight vignette effect for atmosphere
    float dist = distance(UV, vec2(0.5));
    final_color.rgb -= dist * 0.3;
    
    COLOR = final_color;
}
