package shaders;

import flixel.graphics.tile.FlxGraphicsShader;

class BloomShader extends FlxGraphicsShader
{
	@glFragmentSource("
	#pragma header

	const float amount = 2.0;
	
	// GAUSSIAN BLUR SETTINGS
	uniform float dim;
	uniform float Directions;
	uniform float Quality;
	uniform float Size;
	
	vec2 Radius = Size/openfl_TextureSize.xy;
	
	void main(void)
	{
		vec2 uv = openfl_TextureCoordv.xy;
		vec2 pixel  = uv * openfl_TextureSize.xy;
	  float Pi = 6.28318530718; // Pi*2
	  vec4 Color = texture2D(bitmap, uv);
	  for(float d = 0.0; d < Pi; d += Pi / Directions)
	  {
		  for(float i=1.0/Quality; i <= 1.0; i += 1.0 / Quality)
		  {		
		  float ex = (cos(d) * Size * i) / openfl_TextureSize.x;
		  float why = (sin(d) * Size * i) / openfl_TextureSize.y;
		  Color += flixel_texture2D(bitmap, uv + vec2(ex, why));	
		}
	  }
	  Color /= (dim * Quality) * Directions - 15.0;
	  vec4 bloom =  (flixel_texture2D( bitmap, uv) / dim) + Color;
	  gl_FragColor = bloom;
	}
	")

	public function new()
	{
		super();

        dim.value = [1.8];
        Directions.value = [16.0];
        Quality.value = [8.0];
        Size.value = [8.0];
	}
}