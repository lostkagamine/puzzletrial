uniform float u_time;

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{
    vec2 texcoord = texture_coords;
    texcoord.x += tan((texcoord.y+u_time)*6)*0.08;
    vec4 texcolor = Texel(tex, texcoord);
    return texcolor * color;
}