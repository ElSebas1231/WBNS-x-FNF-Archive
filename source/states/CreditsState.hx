package states;

class CreditsState extends MusicBeatState {
	var backMessage:FlxText;
	var textTimer:FlxTimer;

	override function create():Void {
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('alone'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.screenCenter();
		add(bg);

		backMessage = new FlxText(0, 0, FlxG.width, 'Presiona ${ClientPrefs.keyBinds.get('back')[0]} ó ${ClientPrefs.keyBinds.get('back')[1]} para salir...', 32);
		backMessage.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.fromString('#b90900'), CENTER, OUTLINE, FlxColor.BLACK);
		backMessage.screenCenter();
		backMessage.alpha = 0;
		backMessage.scrollFactor.set();
        backMessage.antialiasing = ClientPrefs.data.antialiasing;
		add(backMessage);

		textTimer = new FlxTimer().start(2.5, function(tmr:FlxTimer) {
			FlxTween.tween(backMessage, {alpha: 1}, 1, {ease: FlxEase.smoothStepIn});
		});

		super.create();
	}

	var canLeave:Bool = true;
	override function update(elapsed:Float) {
		if (controls.BACK && canLeave) {
			canLeave = false;
			textTimer.cancel();
			FlxTween.cancelTweensOf(backMessage);
			FlxTween.tween(backMessage, {alpha: 0}, 1, {ease: FlxEase.smoothStepOut});

			new FlxTimer().start(1.5, function(tmr:FlxTimer) {
				MusicBeatState.switchState(new MainMenuState());
			});
		}

		super.update(elapsed);
	}
}
