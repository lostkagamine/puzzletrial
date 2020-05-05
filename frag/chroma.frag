uniform float u_time;
uniform float pos;
uniform bool playing;

float avg(vec3 h) {
    return (h.r + h.g + h.b) / 3;
}

#define THRESHOLD 0.035

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec4 texcolor = Texel(tex, texture_coords);
    if (playing && pos <= 7 && avg(texcolor.rgb) <= THRESHOLD) {
        return vec4(0, 0, 0, 0);
    }
    return texcolor;
}