package objects;

import flixel.sound.FlxSound;
import funkin.vis.dsp.SpectralAnalyzer;

class AudioCircleDisplay extends FlxSpriteGroup
{
	var analyzer:SpectralAnalyzer;

	public var snd:FlxSound;

	var _height:Int;
	public var line:Int;

	public var Radius:Float = 0;
	
	var symmetry:Bool = true;
	var Number:Int = 1;
	
	public var Rotate:Bool = true;
	public var RotateSpeed:Float = 1;
	public var FluentMode:Bool = false;
	public var rate:Float = 10;    // 每秒转动次数
	public var rateNum:Int = -20; //每次转动的跳过条数
	
	var LineX:Float;
	var LineY:Float;
	
	public function new(snd:FlxSound = null, X:Float = 0, Y:Float = 0, Width:Int, Height:Int, line:Int, gap:Int, Color:FlxColor, Radius:Float = 40, symmetry:Bool = false, Number:Int = 5)
	{
		super(X, Y);

		this.snd = snd;
		this.line = line;
		this.Radius = Radius;
		this.symmetry = symmetry;
		if (Number < 1)
			Number = 1;

		this.Number = Number;
		
		LineX = X;
		LineY = Y;

		for (i in 0...line * Number)
		{
			var newLine = new FlxSprite().makeGraphic(gap, 1, Color);
			var angle = (360 / (line * Number)) * i + 1;
			newLine.angle = angle;
			newLine.origin.y = 1;
			var correctedAngle = angle - 90;
			var radians = correctedAngle * Math.PI / 180;
			var moveX = Math.cos(radians) * Radius;
			var moveY = Math.sin(radians) * Radius;
			newLine.x += moveX;
			newLine.y += moveY;
			add(newLine);
		}
		_height = Height;
		@:privateAccess
		if (snd != null)
		{
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

		if (saveTime < ClientPrefs.data.audioDisplayUpdate)
		{
			saveTime += (elapsed * 1000);

			updateLine(elapsed);
			return;
		}
		else
		{
			saveTime = 0;
		}

		getValues = analyzer.getLevels();
		updateLine(elapsed);

        if (Rotate){
		    for (newLine in 0...(members.length - 1)){
		        if (FluentMode){
		            members[newLine].angle += elapsed * RotateSpeed * 20;
		        }
    		    var correctedAngle = members[newLine].angle - 90;
    			var radians = correctedAngle * Math.PI / 180;
    			var moveX = Math.cos(radians) * Radius;
    			var moveY = Math.sin(radians) * Radius;
    			members[newLine].x = LineX + moveX;
    			members[newLine].y = LineY + moveY;
    	    }
		}
        
		super.update(elapsed);
	}

	function addAnalyzer(snd:FlxSound)
	{
		@:privateAccess
		if (snd != null && analyzer == null)
		{
			analyzer = new SpectralAnalyzer(snd._channel.__audioSource, Std.int(line * 1 + Math.abs(0.05 * (4 - ClientPrefs.data.audioDisplayQuality))), 1, 5);
			analyzer.fftN = 256 * ClientPrefs.data.audioDisplayQuality;
		}
	}

	var animFrame:Int = 0;

    var rotationOffset:Float = 0;      // 自动旋转的偏移量
    var rotationSpeed:Float = 2;      // 基础旋转速度（可调快）
    var stepSize:Int = 5;             // 每次跳跃的频段数
    
    function updateLine(elapsed:Float) {
        if (getValues == null) return;
        
        rotationOffset = (rotationOffset + rotationSpeed) % line;
        
        for (i in 0...line) {
            var discreteOffset = Math.floor(rotationOffset / stepSize) * stepSize;
            var rotatedIndex = (i + discreteOffset) % line;

            if (i >= line / 2 && symmetry) {
                animFrame = Math.round(getValues[(line - rotatedIndex) % line].value * _height);
            } else {
                animFrame = Math.round(getValues[rotatedIndex].value * _height);
            }
            
            animFrame = Math.round(animFrame * FlxG.sound.volume);

            for (i1 in 0...Number) {
                var nowLine = i + (i1 * line);
                members[nowLine].scale.y = FlxMath.lerp(
                    animFrame, 
                    members[nowLine].scale.y, 
                    Math.exp(-elapsed * 16)
                );
                if (members[nowLine].scale.y < _height / 40) {
                    members[nowLine].scale.y = _height / 40;
                }
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
		for (i in 0...members.length)
		{
			members[i].scale.y = _height / 40;
			members[i].y = this.y - members[i].scale.y / 2;
		}
	}
}