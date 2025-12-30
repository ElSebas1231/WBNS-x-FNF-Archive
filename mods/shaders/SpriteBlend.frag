#pragma header

uniform float blendStrength;
uniform sampler2D blendBitmap;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    gl_FragColor = mix(flixel_texture2D(bitmap, uv), flixel_texture2D(blendBitmap, uv), blendStrength);
}