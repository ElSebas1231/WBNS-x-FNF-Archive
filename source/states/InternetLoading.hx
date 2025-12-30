package states;

class InternetLoading extends MusicBeatState
{
    public static var leftState:Bool = false;

    var txt:FlxText;
    var alredyReturned:Bool = false;
    var loadingLoopSound:FlxSound;

    override function create() 
    {
        super.create();

        txt = new FlxText(0, 0, 0, 'Connecting to internet...', 40);
        txt.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), 40, 0xFFFFFFFF);
        txt.screenCenter();
        txt.antialiasing = ClientPrefs.data.antialiasing;
        add(txt);

        loadingLoopSound = FlxG.sound.play(Paths.sound('internet_loading/loading_loop'));

        new FlxTimer().start(2, function(t:FlxTimer)
        {
            if(alredyReturned) return;

            confirm();
        });
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(controls.ACCEPT) {
            if (!alredyReturned) {
                confirm();
                alredyReturned = true;
            }
        }
    }

    function confirm()
    {
        if (FlxG.sound.music != null) FlxG.sound.music.pause();
        if (loadingLoopSound != null) loadingLoopSound.pause();
        
        FlxG.sound.play(Paths.sound('internet_loading/confirm'));

        FlxTween.tween(txt, {alpha: 0, y: txt.y - 10}, 1, {ease: FlxEase.quartOut});

        new FlxTimer().start(1.7, function(t:FlxTimer)
        {
            alredyReturned = true;
            leftState = true;
            MusicBeatState.switchState(new TitleState());
        });
    }
}