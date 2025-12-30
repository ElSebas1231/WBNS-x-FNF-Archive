#pragma header

uniform vec3 overrideColor;
uniform float doOverrideColor;

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec4 color = flixel_texture2D(bitmap, uv);

    if (doOverrideColor == 1.0) {
        color.rgb = overrideColor * color.a;
    }
    
    gl_FragColor = color;
}