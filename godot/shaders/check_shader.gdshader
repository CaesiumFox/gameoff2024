shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.25;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    ivec2 fc = ivec2(FRAGCOORD.xy);
    COLOR.a = (fc.x + fc.y) % 2 == 0 ? 1.0 : 0.0;
    
    if (progress < 0.0) {
        COLOR.a = 0.0;
    }
    else if (progress < 0.25) {
        if (progress * 4.0 < UV.x)
            COLOR.a = 0.0;
    }
    else if (progress < 0.5) {
        if ((progress - 0.25) * 4.0 > UV.x)
            COLOR.a = 1.0;
    }
    else if (progress < 0.75) {
        if ((progress - 0.5) * 4.0 < UV.x)
            COLOR.a = 1.0;
    }
    else if (progress < 1.0) {
        if ((progress - 0.75) * 4.0 > UV.x)
            COLOR.a = 0.0;
    }
    else {
        COLOR.a = 0.0;
    }
}
