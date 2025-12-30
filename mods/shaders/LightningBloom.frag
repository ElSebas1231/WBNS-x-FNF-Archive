#pragma header

uniform float strength;
uniform float dirX;
uniform float dirY;

void main()
{
    vec2 texOffset = (1.0 / openfl_TextureSize.xy) * strength * vec2(dirX, dirY);
    vec2 uv = openfl_TextureCoordv;
    vec4 color = vec4(0.0, 0.0, 0.0, 0.0);

    color += flixel_texture2D(bitmap, uv + (texOffset * -3.0)) * 0.0765172369481377;
    color += flixel_texture2D(bitmap, uv + (texOffset * -2.0)) * 0.1333625808274777;
    color += flixel_texture2D(bitmap, uv + (texOffset * -1.0)) * 0.18612247484437577;

    color += flixel_texture2D(bitmap, uv) * 0.20799541476001773;

    color += flixel_texture2D(bitmap, uv + (texOffset * 1.0)) * 0.18612247484437577;
    color += flixel_texture2D(bitmap, uv + (texOffset * 2.0)) * 0.1333625808274777;
    color += flixel_texture2D(bitmap, uv + (texOffset * 3.0)) * 0.0765172369481377;

    float lum = clamp(dot(color.rgb, vec3(0.2125, 0.7154, 0.0721)), 0.0, 1.0);

    //this is actually incorrect bloom cuz its bluring darker areas more, but it looks better lol
    color = mix(color, flixel_texture2D(bitmap, uv), lum);
    gl_FragColor = color;
}