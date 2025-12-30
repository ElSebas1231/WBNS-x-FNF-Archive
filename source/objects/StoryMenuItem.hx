package objects;

class StoryMenuItem extends FlxSprite
{
	public var targetY:Float = 0;
	public var isFlashing(default, set):Bool = false;

	private var _flashingElapsed:Float = 0;
	final _flashColor = 0xFF33FFFF;
	final flashes_ps:Int = 6;

	public function new(weekName:String = '', locked:Bool = false) {
		super(x, y);
		
		if (Paths.fileExists('images/ui/menus/storymenu/islands/${weekName}.xml', TEXT)) {
			frames = Paths.getSparrowAtlas('ui/menus/storymenu/islands/${weekName}');
			animation.addByPrefix('idle', 'idle', 24, false);
			animation.addByPrefix('locked', 'locked', 24, false);
			animation.play(locked ? 'locked' : 'idle', true);
		} else {
			loadGraphic(Paths.image('images/ui/menus/storymenu/islands/$weekName'));
		}

		scale.set(0.8, 0.8);
		screenCenter(Y);
		antialiasing = ClientPrefs.data.antialiasing;
	}

	public function set_isFlashing(value:Bool = true):Bool {
		isFlashing = value;
		_flashingElapsed = 0;
		color = (isFlashing) ? _flashColor : FlxColor.WHITE;
		return isFlashing;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		x = FlxMath.lerp(x, (targetY * 700) + 250, FlxMath.bound(elapsed * 6));

		if (isFlashing) {
			_flashingElapsed += elapsed;
			color = (Math.floor(_flashingElapsed * FlxG.updateFramerate * flashes_ps) % 2 == 0) ? _flashColor : FlxColor.WHITE;
		}
	}
}
