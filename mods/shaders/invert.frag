#pragma header
		
void main()
{
	vec2 uv = openfl_TextureCoordv;
	vec4 col = flixel_texture2D(bitmap, uv);
	col.r = -col.r + 1.0;
	col.g = -col.g + 1.0;
	col.b = -col.b + 1.0;
	gl_FragColor = col * col.a;
}