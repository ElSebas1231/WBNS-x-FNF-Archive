#pragma header

uniform sampler2D mask;
uniform float xPercent;
uniform float yPercent;

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec4 color = flixel_texture2D(bitmap, uv);
    vec4 maskC = flixel_texture2D(mask, uv);
    
    if (maskC.x > xPercent)
    {
        color = vec4(0.0, 0.0, 0.0, 0.0);
    }
    
    gl_FragColor = color;
}