#pragma header

#define PI 3.14159265359

uniform float uTime;
uniform float tvFrequency;
uniform float tvIntensity;
uniform float tvDistorcion;

uniform float vignetteIntensity;
uniform bool vignetteFollowAlpha;

uniform float chromIntensity;

uniform bool lineTv;
uniform float lineFrequency;
uniform float lineSize;
uniform float lineSpace;
uniform float lineOffset;
uniform float multiply;

uniform float contrast;

vec2 barrelDistortion (vec2 coord, float amt){
	vec2 cc = coord - 0.5;
	float dist = dot(cc, cc);
	return coord + cc * dist * amt;
}

void main() {
	vec2 uv = openfl_TextureCoordv;

	if(tvDistorcion != 0.0){
		uv = barrelDistortion(uv,tvDistorcion);
	}

	float vigUv = pow(sin(uv.x*PI) * sin(uv.y*PI),1.5);
	uv.x += (sin((uv.y*3.0-(uTime*tvFrequency))*30.0)*tvIntensity);
	if(lineTv){
		float y = mod(uv.y-uTime*lineFrequency,lineSpace);
		if(y < lineSize){
			uv.x -= lineOffset * float(int(sin((y/lineSize)*PI)*3.0))/2.0;
		}
	}
	
	vec4 normal_map = flixel_texture2D(bitmap,uv);

	float vigCal = 1.0;
	if(uv.x <= 0.0 || uv.x >= 1.0 || uv.y <= 0.0 || uv.y >= 1.0){
		normal_map.rgb = vec3(0.0);
		vigCal = 0.0;
	}
	else{
		vigCal = smoothstep(0.0,1.0,vigUv/max(vignetteIntensity,0.0001));
		if(chromIntensity != 0.0){
			vec2 red = flixel_texture2D(bitmap,vec2(uv.x - chromIntensity,uv.y)).ra;
			vec2 blue = flixel_texture2D(bitmap,vec2(uv.x + chromIntensity,uv.y)).ba;
			normal_map.r = red.x;
			normal_map.b = blue.x;
			normal_map.a += ((red.y - normal_map.a)*red.x) + ((blue.y - normal_map.a)*blue.x);
		}
	}
	//Lines Effect
	normal_map.rgb = (normal_map.rgb - sin(uv.y*800.0)*0.04);
	if(contrast != 0.0){
		normal_map.rgb = (normal_map.rgb - vec3(0.5)) * (1.0 + contrast) + vec3(0.5);
		normal_map.a = max(normal_map.a,abs(normal_map.a - contrast));
	}

	//Vignette Effect
	
	if(!vignetteFollowAlpha){
		normal_map.rgb *= vigCal;
		normal_map.a = mix(normal_map.a,1.0,1.0 - vigCal);
	}
	else{
		normal_map.rgb *= vigCal * normal_map.a;
	}		

    gl_FragColor = vec4(normal_map.rgb * multiply,normal_map.a);
}