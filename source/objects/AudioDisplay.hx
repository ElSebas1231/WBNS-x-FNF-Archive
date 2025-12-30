package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioDisplay extends FlxSpriteGroup
{
	var analyzer:SpectralAnalyzer;

	public var snd:FlxSound;

	var _height:Int;
	var line:Int;

	var symmetry:Bool = false;
	var downwards:Bool = false;
	var horizontal:Bool = false;

	public function new(snd:FlxSound = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, symmetry:Bool = false, downwards:Bool = false, horizontal:Bool = false)
	{
		super(X, Y);

		this.snd = snd;
		this.line = line;
		this.symmetry = symmetry;
		this.downwards = downwards;
		this.horizontal = horizontal;

		for (i in 0...line) {
			if (horizontal) {
				var newLine = new FlxSprite().makeGraphic(1, Std.int(Height / line - gap), Color);
				newLine.y = (Height / line) * i;
				add(newLine);
			} else {
				var newLine = new FlxSprite().makeGraphic(Std.int(Width / line - gap), 1, Color);
				newLine.x = (Width / line) * i;
				add(newLine);
			}
		}

		_height = Height;
		
		@:privateAccess
		if (snd != null) {
			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
			analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
		}
	}

	public var stopUpdate:Bool = false;

	var saveTime:Float = 0;
	var getValues:Array<funkin.vis.dsp.Bar>;

	override function update(elapsed:Float)
	{
		if (stopUpdate)
			return;

		if (saveTime < ClientPrefs.data.audioDisplayUpdate) {
			saveTime += (elapsed * 1000);

			updateLine(elapsed);
			return;
		} else saveTime = 0;

		getValues = analyzer.getLevels();
		updateLine(elapsed);

		super.update(elapsed);
	}

	function addAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		if (snd != null && analyzer == null) {
			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
			analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
		}
	}

	var animFrame:Int = 0;

	function updateLine(elapsed:Float)
	{
		if (getValues == null)
			return;

		for (i in 0...members.length) {
			if (i >= members.length / 2 && symmetry)
				animFrame = Math.round(getValues[members.length - 1 - i].value * _height);
			else
				animFrame = Math.round(getValues[i].value * _height);

			animFrame = Math.round((animFrame * FlxG.sound.volume) / 2);

			if (horizontal) {
				members[i].scale.x = FlxMath.lerp(animFrame, members[i].scale.x, Math.exp(-elapsed * 16));
				if (members[i].scale.x < _height / 40)
					members[i].scale.x = _height / 40;

				if (downwards)
					members[i].x = this.x + members[i].scale.x / 2;
				else
					members[i].x = this.x - members[i].scale.x / 2;
			} else {
				members[i].scale.y = FlxMath.lerp(animFrame, members[i].scale.y, Math.exp(-elapsed * 16));
				if (members[i].scale.y < _height / 40)
					members[i].scale.y = _height / 40;
				
				if (downwards)
					members[i].y = this.y + members[i].scale.y / 2;
				else
					members[i].y = this.y - members[i].scale.y / 2;
			}
		}
	}

	public function changeAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		analyzer.changeSnd(snd._channel.__audioSource);

		stopUpdate = false;
	}

	public function clearUpdate()
	{
		for (i in 0...members.length) {
			if (horizontal) {
				members[i].scale.x = _height / 40;
				if (downwards)
					members[i].x = this.x + members[i].scale.x / 2;
				else
					members[i].x = this.x - members[i].scale.x / 2;
			} else {
				members[i].scale.y = _height / 40;
				if (downwards)
					members[i].y = this.y + members[i].scale.y / 2;
				else
					members[i].y = this.y - members[i].scale.y / 2;
			}
		}
	}
}