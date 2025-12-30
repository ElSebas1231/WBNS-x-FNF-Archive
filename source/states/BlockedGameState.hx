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

		if(FlxG.sound.music != null) FlxG.sound.music.stop();

        Cursor.show();
        twtHitbox = new FlxSprite(1040, 0).makeGraphic(170, 20, 0xFFFFFFFF);
        twtHitbox.screenCenter(Y);
        twtHitbox.y += -10;
        twtHitbox.visible = false;
        add(twtHitbox);
        
        txt = new FlxText(0, 0, FlxG.width, 'Your game has been blocked by the administrator. If there\'s not a warning in the Twitter account \nof the mod, please report this as a bug\n\nPress ENTER to Reset the game.', 18);
		txt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        txt.applyMarkup('Your game has been blocked by the administrator. If there\'s not a warning in the /Twitter account/ \nof the mod, please report this as a bug\n\nPress ENTER to Reset the game.',
            [new FlxTextFormatMarkerPair(new FlxTextFormat(0x1E9DE7), "/")]);
        txt.screenCenter(Y);
        txt.antialiasing = ClientPrefs.data.antialiasing;
        add(txt);

        urlLine = new FlxSprite(1040, 0).makeGraphic(170, 1, 0xFF1E9DE7);
        urlLine.alpha = 0;
        urlLine.x = 1036;
        urlLine.y = 353;
        urlLine.antialiasing = ClientPrefs.data.antialiasing;
        lastAlpha = 0;
        add(urlLine);

        activatedTxt = new FlxText(0, 0, FlxG.width, 'The build has been activated!', 20);
        activatedTxt.setFormat(Paths.font("vcr.ttf"), 26, 0xFF30DB30, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        activatedTxt.screenCenter(Y);
        activatedTxt.visible = false;
        activatedTxt.antialiasing = ClientPrefs.data.antialiasing;
        add(activatedTxt);
    }

	public static var transitioning:Bool = false;
    override function update(elapsed:Float) 
    {
        Thread.create(function() { Blocker.fetchInfo(); });

        #if debug
        if (FlxG.keys.justPressed.ONE) { //unlock
            transitioning = true;
            displayUnlockText();
            new FlxTimer().start(2.7, function(t:FlxTimer) {
                FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() {
                    MusicBeatState.switchState(new TitleState());
                }, false);
            });
        }
        #end

        if (!transitioning) {
            if (Blocker.isBlocked == false) {
                transitioning = true;
                displayUnlockText();
                new FlxTimer().start(2.7, function(t:FlxTimer) {
                    FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() {
                        MusicBeatState.switchState(new TitleState());
                    }, false);
                });
            }

            if (FlxG.keys.justPressed.ENTER) {
                transitioning = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                new FlxTimer().start(2.7, function(t:FlxTimer) {
                    FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() {
                        MusicBeatState.switchState(new TitleState());
                    }, false);
                });
            }

            if (FlxG.mouse.overlaps(twtHitbox)) {
                var currentAlpha = 1;
                if(lastAlpha != currentAlpha){
                    lastAlpha = currentAlpha;
                    if(urlLineTwn != null) urlLineTwn.cancel();

                    urlLineTwn = FlxTween.tween(urlLine, {alpha: 1}, 0.2, {onComplete: function(t:FlxTween) {
                        urlLineTwn = null;
                    }});
                }

                if (FlxG.mouse.justPressed) CoolUtil.browserLoad('https://x.com/WBNSxFNFmod');
            } else {
                var currentAlpha = 0;
                if(lastAlpha != currentAlpha){
                    lastAlpha = currentAlpha;
                    if (urlLineTwn != null) urlLineTwn.cancel();

                    urlLineTwn = FlxTween.tween(urlLine, {alpha: 0}, 0.2, {onComplete: function(t:FlxTween) {
                        urlLineTwn = null;
                    }});
                }
            }
        }
    }

    function displayUnlockText() {
        urlLine.visible = false;
        txt.visible = false;
        activatedTxt.visible = true;
        FlxG.sound.play(Paths.sound('confirmMenu'));
    }
}