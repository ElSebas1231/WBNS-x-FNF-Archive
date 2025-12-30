package objects;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxG;

import shaders.RGBPalette;
import shaders.RGBPalette.RGBShaderReference;

import objects.Note;

using StringTools;

/*
	Code from FNF FPS+ used as based
	Modified by ElSebas1231

	All credits to Rozebud
*/

class NoteHoldCover extends FlxSprite{
    public var noteDirection:Int = 0;
	public var rgbShader:PixelShaderRef;
    var posOffset:FlxPoint = new FlxPoint();

    var referenceSprite:FlxSprite;

    public function new(_referenceSprite:FlxSprite, note:Int){

        super(0, 0);

        noteDirection = note;
        referenceSprite = _referenceSprite;
        
        var noteColor:String;

        switch(noteDirection){
            case 1:
                noteColor = "Blue";
            case 2:
                noteColor = "Green";
            case 3:
                noteColor = "Red";
			default:
				noteColor = "Purple";
        }

        frames = Paths.getSparrowAtlas('noteHoldCovers');
        antialiasing = (PlayState.isPixelStage ? false : ClientPrefs.data.antialiasing);
        animation.addByPrefix("start", "holdCoverStart" + noteColor, 24, false);
        animation.addByPrefix("hold", "holdCover" + noteColor, 20, true);
        animation.addByPrefix("end", "holdCoverEnd" + noteColor, FlxG.random.int(20, 24), false);
        animation.finishCallback = callback;
        visible = false;
        animation.play("start");
        offset.set(162, 155);
        posOffset.set(55, 55);

        rgbShader = new PixelShaderRef();
		shader = rgbShader.shader;
    }
    
    override function update(elapsed:Float) {
        if (referenceSprite == null) destroy();

        x = referenceSprite.x + posOffset.x;
        y = referenceSprite.y + posOffset.y;

		if((animation.curAnim.name == 'end' && animation.curAnim.finished)) {
            visible = false;
        }

        super.update(elapsed);
    }

	// Copied literally from NoteSplash.hx
    public function holdCoverRGBValue(?note:Note = null)
    {
		var tempShader:RGBPalette = null;
		if ((note == null || note.noteCoverData.useRGBShader) && (PlayState.SONG == null || !PlayState.SONG.disableNoteRGB)) {
			alpha = note.alpha;
			// If Note RGB is enabled:
			if(note != null && !note.noteCoverData.useGlobalShader)
			{	
				if (note.noteCoverData.r != -1) note.rgbShader.r = note.noteCoverData.r;
				if(note.noteCoverData.g != -1) note.rgbShader.g = note.noteCoverData.g;
				if(note.noteCoverData.b != -1) note.rgbShader.b = note.noteCoverData.b;
				
				tempShader = note.rgbShader.parent;
			} else tempShader = Note.globalRgbShaders[noteDirection];
		} else {
			note.rgbShader.r = FlxColor.RED;
			note.rgbShader.g = FlxColor.GREEN;
			note.rgbShader.b = FlxColor.BLUE;
		}

		rgbShader.copyValues(tempShader);
    }

    public function start() {
        visible = !ClientPrefs.data.hideNoteCovers;
        animation.play("start");
    }

    public function end(playSplash:Bool) {
        visible = playSplash && !ClientPrefs.data.hideNoteCovers;
        animation.play("end");
    }

	public function getAnim():String {
		var name:String = '';
		if (animation.curAnim != null) name = animation.curAnim.name;
		return name;
	}

    function callback(anim:String) {
        switch(anim){
            case "start":
                animation.play("hold");

            case "end":
                visible = false;
        }
    }
}

class PixelShaderRef {
	public var shader:PixelShader = new PixelShader();

	public function copyValues(tempShader:RGBPalette)
	{
		var enabled:Bool = false;
		if(tempShader != null)
			enabled = true;

		if(enabled) {
			for (i in 0...3)
			{
				shader.r.value[i] = tempShader.shader.r.value[i];
				shader.g.value[i] = tempShader.shader.g.value[i];
				shader.b.value[i] = tempShader.shader.b.value[i];
			}
			shader.mult.value[0] = tempShader.shader.mult.value[0];
		}
		else shader.mult.value[0] = 0.0;
	}
    
	public function new()
	{
		shader.r.value = [0, 0, 0];
		shader.g.value = [0, 0, 0];
		shader.b.value = [0, 0, 0];
		shader.mult.value = [1];

		var pixel:Float = 1;
		if(PlayState.isPixelStage) pixel = 4;
		shader.uBlocksize.value = [pixel, pixel];
	}
}

class PixelShader extends FlxShader
{
	@:glFragmentHeader('
		#pragma header
		
		uniform vec3 r;
		uniform vec3 g;
		uniform vec3 b;
		uniform float mult;
		uniform vec2 uBlocksize;

		vec4 flixel_texture2DCustom(sampler2D bitmap, vec2 coord) {
			vec2 blocks = openfl_TextureSize / uBlocksize;
			vec4 color = flixel_texture2D(bitmap, floor(coord * blocks) / blocks);
			if (!hasTransform) {
				return color;
			}

			if(color.a == 0.0 || mult == 0.0) {
				return color * openfl_Alphav;
			}

			vec4 newColor = color;
			newColor.rgb = min(color.r * r + color.g * g + color.b * b, vec3(1.0));
			newColor.a = color.a;
			
			color = mix(color, newColor, mult);
			
			if(color.a > 0.0) {
				return vec4(color.rgb, color.a);
			}
			return vec4(0.0, 0.0, 0.0, 0.0);
		}')

	@:glFragmentSource('
		#pragma header

		void main() {
			gl_FragColor = flixel_texture2DCustom(bitmap, openfl_TextureCoordv);
		}')

	public function new()
	{
		super();
	}
}