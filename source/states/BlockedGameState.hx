package states;

import sys.thread.Thread;
import backend.build.Blocker;

class BlockedGameState extends MusicBeatState
{
    var twtHitbox:FlxSprite;
    var txt:FlxText;
    var activatedTxt:FlxText;
    var urlLine:FlxSprite;
    var urlLineTwn:FlxTween;
    var lastAlpha:Float;

    override function create() 
    {
        super.create();

		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();

        FlxG.mouse.visible = true;

        twtHitbox = new FlxSprite(1040, 0).makeGraphic(170, 20, 0xFFFFFFFF);
        twtHitbox.screenCenter(Y);
        twtHitbox.y += -10;
        add(twtHitbox);

        #if !debug
            twtHitbox.visible = false;
        #end
        
        txt = new FlxText(0, 0, FlxG.width, 'Your build has been blocked by the administrator. If there\'s not a warning in the Twitter account \nof the mod, please report this as a bug', 18);
		txt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        txt.applyMarkup('Your build has been blocked by the administrator. If there\'s not a warning in the /Twitter account/ \nof the mod, please report this as a bug',
            [new FlxTextFormatMarkerPair(new FlxTextFormat(0x1E9DE7), "/")]);
        txt.screenCenter(Y);
        txt.antialiasing = ClientPrefs.data.antialiasing;
        add(txt);

        urlLine = new FlxSprite(1040, 0).makeGraphic(170, 1, 0xFF1E9DE7);
        urlLine.screenCenter(Y);
        urlLine.alpha = 0;
        urlLine.y += 2;
        urlLine.antialiasing = ClientPrefs.data.antialiasing;
        lastAlpha = 0;
        add(urlLine);

        activatedTxt = new FlxText(0, 0, FlxG.width, 'The build has been activated!', 20);
        activatedTxt.setFormat(Paths.font("vcr.ttf"), 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        activatedTxt.screenCenter(Y);
        activatedTxt.visible = false;
        activatedTxt.antialiasing = ClientPrefs.data.antialiasing;
        add(activatedTxt);
    }

	public static var alredyLoaded:Bool = false;
    private static var manuallyPressed:Bool = false;

    override function update(elapsed:Float) 
    {
        Thread.create(function() 
		{
			Blocker.fetchInfo();
		});

        #if NO_ACTIVE
        if(FlxG.keys.justPressed.ENTER) //unlock pressing enter
        {
            Blocker.isBlocked = false;
            manuallyPressed = true;
        }
        #end

		if(!Blocker.isBlocked && !alredyLoaded)
		{
            #if !NO_ACTIVE
			    //Sys.exit(1); kinda troll, isn't it?
			    MusicBeatState.alredyLoaded = false;
			    alredyLoaded = true;

                urlLine.visible = false;
                txt.visible = false;
                activatedTxt.visible = true;
                FlxG.sound.play(Paths.sound('confirmMenu'));

                new FlxTimer().start(2.7, function(t:FlxTimer) 
                {
			    	FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
                });
            #else
                if(manuallyPressed)
                {
                    //Sys.exit(1); kinda troll, isn't it?
                    MusicBeatState.alredyLoaded = false;
                    alredyLoaded = true;
    
                    urlLine.visible = false;
                    txt.visible = false;
                    activatedTxt.visible = true;
                    FlxG.sound.play(Paths.sound('confirmMenu'));
    
                    new FlxTimer().start(2.7, function(t:FlxTimer) 
                    {
                        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
                    });
                }
            #end
		}

        if(FlxG.mouse.overlaps(twtHitbox))
        {
            var currentAlpha = 1;
            if(lastAlpha != currentAlpha)
            {
                lastAlpha = currentAlpha;
                if(urlLineTwn != null)
                {
                    urlLineTwn.cancel();
                }

                urlLineTwn = FlxTween.tween(urlLine, {alpha: 1}, 0.2, {onComplete: function(t:FlxTween)
                {
                    urlLineTwn = null;
                }});
            }

            if(FlxG.mouse.justPressed)
            {
                CoolUtil.browserLoad('https://x.com/WBNSxFNFmod');
            }
        }
        else
        {
            var currentAlpha = 0;
            if(lastAlpha != currentAlpha)
            {
                lastAlpha = currentAlpha;
                if(urlLineTwn != null)
                {
                    urlLineTwn.cancel();
                }

                urlLineTwn = FlxTween.tween(urlLine, {alpha: 0}, 0.2, {onComplete: function(t:FlxTween)
                {
                    urlLineTwn = null;
                }});
            }
        } 
    }
}