package objects;

class FlagIcon extends FlxSprite {

	public var sprTracker:FlxSprite;
	public var flag:String = '';

	public function new(flag:String, ?allowGPU:Bool = true)
	{
		super();

		createFlagSprite(flag, allowGPU);
		scrollFactor.set();
	}

	public function createFlagSprite(flag:String, ?allowGPU:Bool = true) {
		if (this.flag != flag) {
			var name:String = 'flagsIcons/' + flag;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'flagsIcons/' + Language.defaultLangFlag; // Defaults to US Flag
			
			var graphic = Paths.image(name, allowGPU);
			loadGraphic(graphic);
			updateHitbox();

			this.flag = flag;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null) setPosition(sprTracker.x + sprTracker.width + 20, sprTracker.y - 10);
	}
}