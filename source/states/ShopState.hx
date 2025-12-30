package states;

class ShopState extends MusicBeatState
{
    override function create() 
    {
        super.create();

        Cursor.show();
        
		var text:FlxText = new FlxText(0, 0, FlxG.width - 300, 'Placeholder', 32);
		text.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.scrollFactor.set();
		text.borderSize = 2;
		text.screenCenter();
		add(text);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
    }
}