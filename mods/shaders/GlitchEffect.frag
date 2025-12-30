#pragma header

uniform float uTime;
uniform float intensity;
void main() {
	vec2 uv = openfl_TextureCoordv;
	vec4 normal_map = flixel_texture2D(bitmap,uv);
	if(intensity != 0.0){
		float cal = sin(uv.y*1000.0)*intensity;
		cal += (sin(uv.y*400.0+uTime*20.0))*0.0015;
		vec4 glitchColor = flixel_texture2D(bitmap,vec2(uv.x-cal,uv.y));
		
		normal_map += abs(normal_map - glitchColor)*min(1.3,intensity*800.);
		//normal_map = glitchColor;
	}
	gl_FragColor = normal_map;
}