#pragma header

uniform float iTime;


vec4 render( vec2 uv )
{
    uv.x += iTime;

    return flixel_texture2D( bitmap, vec2(abs(mod(uv.x, 1.0)), abs(mod(uv.y, 1.0))) );
}

void main()
{	    
    vec2 uv = openfl_TextureCoordv.xy;
    uv.x *= 25.0;
    
    gl_FragColor = render(uv);
}