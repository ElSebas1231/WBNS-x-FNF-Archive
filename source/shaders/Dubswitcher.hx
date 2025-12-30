package shaders;

class Dubswitcher extends FlxShader
{
	@glFragmentSource('
	
	// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

	#pragma header
	
	#define round(a) floor(a + 0.5)
	#define iResolution vec3(openfl_TextureSize, 0.)
	uniform float iTime;
	#define iChannel0 bitmap
	uniform sampler2D iChannel1;
	uniform sampler2D iChannel2;
	uniform sampler2D iChannel3;
	#define texture flixel_texture2D
	
	// third argument fix
	vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
		vec4 color = texture2D(bitmap, coord, bias);
		if (!hasTransform)
		{
			return color;
		}
		if (color.a == 0.0)
		{
			return vec4(0.0, 0.0, 0.0, 0.0);
		}
		if (!hasColorTransform)
		{
			return color * openfl_Alphav;
		}
		color = vec4(color.rgb / color.a, color.a);
		mat4 colorMultiplier = mat4(0);
		colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
		colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
		colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
		colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
		color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
		if (color.a > 0.0)
		{
			return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
		}
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	
	// variables which is empty, they need just to avoid crashing shader
	uniform float iTimeDelta;
	uniform float iFrameRate;
	uniform int iFrame;
	#define iChannelTime float[4](iTime, 0., 0., 0.)
	#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
	uniform vec4 iMouse;
	uniform vec4 iDate;
	
	void findRatio (in vec2 res, out vec2 rat) {
		vec2 r = res;
		float gcf;
		for(float i = 1.; i <= r.x && i <= r.y; ++i)  
		{  
			if (mod(r.x,float(i)) == 0. && mod(r.y,float(i)) == 0.)  
				gcf = float(i);
		}
		//r /= gcf;
		//rat = r;
	}
	
	vec2 hash(in vec2 x) {
	   vec2 p = fract(sin(x.yx*3000.)*54321.);
	   return fract(p);
	}
	
	uniform float intensity = 0.2;
	
	void mainImage( out vec4 fragColor, in vec2 coord )
	{
		vec2 ires = iResolution.xy;
		vec2 rRatio;
		findRatio(ires,rRatio);
		
		vec2 uv = coord/ires;
		vec2 uv2 = fract(uv*rRatio*iResolution.x*16.);
		
		vec2 rand = (hash(uv+iTime)-0.5)*intensity;
		rand.y /= 10.;
		
		vec3 col1 = texture(iChannel0,uv+rand/4.).rgb;
		
		float disp = dot(col1,vec3(0.,0.,0.));
		uv2 /= (disp-0.5)*0.1+rand;
		//uv2 += fract((disp-0.5)*10.);
		
		
		vec3 col2 = texture(iChannel0,uv2).rgb*col1/12.;
		
		col1 -= col2;
		
		
		fragColor = vec4(col1,texture(iChannel0, uv).a);
	}
	
	void main() {
		mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
	}

	')

	public function new()
	{
		super();
		iTime.value = [0.0];
	}
}