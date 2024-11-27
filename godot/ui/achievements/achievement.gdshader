shader_type canvas_item;

uniform int id;
uniform sampler2D base;

ivec2 shift1() {
    switch(id) {
    case 0:  return ivec2( 0,  0);
    case 1:  return ivec2( 6,  0);
    case 2:  return ivec2(12,  0);
    case 3:  return ivec2(18,  0);
    case 4:  return ivec2( 0,  6);
    case 5:  return ivec2( 6,  6);
    case 6:  return ivec2(12,  6);
    case 7:  return ivec2(18,  6);
    default: return ivec2( 0,  0);
    }
}

ivec2 shift2() {
    return shift1() + ivec2(0, 12);
}

ivec2 to_ivec(vec2 uv) {
    return ivec2(floor(uv * vec2(6.0, 6.0)));
}

void fragment() {
	COLOR.a = 1.0;
    bool t1 = texelFetch(base, shift1() + to_ivec(UV), 0).r > 0.5;
    bool t2 = texelFetch(base, shift2() + to_ivec(UV), 0).r > 0.5;
    COLOR.rgb = vec3(t1 != t2 ? 1.0 : 0.0);
}
