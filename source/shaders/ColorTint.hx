package shaders;

class ColorTint {
    public var shader(default, null):ColorTintShader = new ColorTintShader();
    public var rLM(default, set):Float = 0.0;
    public var gLM(default, set):Float = 0.0;
    public var bLM(default, set):Float = 0.0;

    public var rOffset(default, set):Float = 0.0;
    public var gOffset(default, set):Float = 0.0;
    public var bOffset(default, set):Float = 0.0;

    public var uMix(default, set):Float = 0.0;

    private function set_rLM(value:Float) {
        rLM = value;
		shader.rLM.value = [rLM];
		return value;
	}

    private function set_gLM(value:Float) {
        gLM = value;
		shader.gLM.value = [gLM];
		return value;
	}

    private function set_bLM(value:Float) {
        bLM = value;
		shader.bLM.value = [bLM];
		return value;
	}

    private function set_rOffset(value:Float) {
        rOffset = value;
		shader.rOffset.value = [rOffset];
		return value;
	}

    private function set_gOffset(value:Float) {
        gOffset = value;
		shader.gOffset.value = [gOffset];
		return value;
	}

    private function set_bOffset(value:Float) {
        bOffset = value;
		shader.bOffset.value = [bOffset];
		return value;
	}

    private function set_uMix(value:Float) {
        uMix = value;
		shader.uMix.value = [uMix];
		return value;
	}

    public function new() {
        shader.rLM.value = [0.05];
        shader.gLM.value = [0.74];
        shader.bLM.value = [0.114];

        shader.rOffset.value = [1.0];
        shader.gOffset.value = [0.0];
        shader.bOffset.value = [0.0];

        shader.uMix.value = [0.0];
	}
}

class ColorTintShader extends FlxShader
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
    }
}