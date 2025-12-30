package shaders;

class RedBlackShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float rLM; // Red Luminosity Method
        uniform float gLM; // Green Luminosity Method
        uniform float bLM; // Blue Luminosity Method

        uniform float rOffset;
		uniform float gOffset;
		uniform float bOffset;

        uniform float uMix;

        void main() {
            vec2 uv = openfl_TextureCoordv.xy;
            vec4 color = texture2D(bitmap, uv);
            
            float gray = dot(color.rgb, vec3(rLM, gLM, bLM));
            float t = smoothstep(0.4, 0.6, gray);
            vec3 outputColor = mix(vec3(0.0), vec3(rOffset, gOffset, bOffset), t);

            vec3 finalColor = mix(color.rgb, outputColor, uMix);

            gl_FragColor = vec4(finalColor, color.a);
        }
    ')

    public function new() {
        super();

        rLM.value = [0.05];
        gLM.value = [0.74];
        bLM.value = [0.114];

        rOffset.value = [1.0];
        gOffset.value = [0.0];
        bOffset.value = [0.0];

        uMix.value = [0.0];
    }
}