package states.freeplay;

import flixel.graphics.FlxGraphic;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import shaders.ColorTint;

class FreeplaySections extends MusicBeatState {
    var bgImage:FlxSprite;
    var freeplayTablets:FlxSprite;

    var sectionSprite:FlxSprite;
    var logo:FlxSprite;
    var selectorTablet:FlxSprite;
    var freeplayTitle:FlxSprite;
    var titleBack:FlxSprite;

    private static var curSelected:Int = 0;
    public static var sectionSelected:String = '';
    public static var freeplaySections:Array<String> = ['duxomadness']; 

    var bottomText:FlxText;
	var bottomBG:FlxSprite;
	var swagShader:ColorTint = null;

    override function create():Void {
        Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

        if (FlxG.mouse.visible) Cursor.hide();
        
        if (FlxG.sound.music == null) {
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
            FlxG.sound.music.fadeIn(1.5, 0, 1);
        }

        // YES THIS COULD HAPPEND
        if (FlxG.sound.music.volume == 0 || FlxG.sound.music.volume < 1) FlxG.sound.music.fadeIn(1.5, FlxG.sound.music.volume, 1);

        swagShader = new ColorTint();
		swagShader.uMix = 0.8;
        
		var bgStars:FlxSprite = new FlxSprite();
		bgStars.antialiasing = ClientPrefs.data.antialiasing;
		bgStars.loadGraphic(Paths.image('ui/menus/utils/stars'));
		add(bgStars);

        bgImage = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/space_background'));
        bgImage.antialiasing = ClientPrefs.data.antialiasing;
        bgImage.screenCenter();
        add(bgImage);

        freeplayTablets = new FlxSprite(0, 0);
        freeplayTablets.antialiasing = ClientPrefs.data.antialiasing;
        freeplayTablets.frames = Paths.getSparrowAtlas('ui/menus/freeplay/tab/freeplay tablets');
        freeplayTablets.animation.addByPrefix('intro', 'freeplay tablets tablets intro0', 24, false);
        freeplayTablets.animation.addByPrefix('idle', 'freeplay tablets tablets idle0', 24, true);
        freeplayTablets.animation.addByPrefix('lock pressed', 'freeplay tablets tablets press locked0', 24, false);
        freeplayTablets.animation.addByPrefix('turn', 'freeplay tablets tablets turn0', 24, false);
        freeplayTablets.animation.addByPrefix('turn inv', 'freeplay tablets tablets turn inverted0', 24, false);
        freeplayTablets.scale.set(0.9, 0.9);
        freeplayTablets.screenCenter();
        freeplayTablets.y -= 40;
        add(freeplayTablets);

        logo = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/duxomadness_logo'));
        logo.antialiasing = ClientPrefs.data.antialiasing;
        logo.alpha = 0;
        logo.x = 430;
        logo.y = 100;
        logo.scale.set(0.75, 0.75);
        logo.updateHitbox();
        add(logo);

        selectorTablet = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/title tablet selector'));
        selectorTablet.antialiasing = ClientPrefs.data.antialiasing;
        selectorTablet.screenCenter();
        selectorTablet.y += 260;
        selectorTablet.alpha = 0;
        selectorTablet.scale.set(1.2, 1.2);
        add(selectorTablet);

        sectionSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/sec_duxomadness'));
        sectionSprite.screenCenter();
        sectionSprite.y += 260;
        sectionSprite.alpha = 0;
        sectionSprite.antialiasing = ClientPrefs.data.antialiasing;
        add(sectionSprite);

        titleBack = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/title_back'));
        titleBack.screenCenter();
        titleBack.antialiasing = ClientPrefs.data.antialiasing;
        titleBack.y = -50;
        add(titleBack);

        freeplayTitle = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/freeplay_title'));
        freeplayTitle.screenCenter();
        freeplayTitle.x = 476;
        freeplayTitle.y = -200;
		freeplayTitle.scale.set(0.85, 0.85);
        freeplayTitle.antialiasing = ClientPrefs.data.antialiasing;
        add(freeplayTitle);

        bottomBG = new FlxSprite(0, 0).makeGraphic(FlxG.width, 26, 0xFF000000);
        bottomBG.y = 754;
		bottomBG.alpha = 0.6;
		add(bottomBG);

        var leText:String = Language.getPhrase(
            'freeplay_tip', 
            '[${ClientPrefs.keyBinds.get('ui_left')[0]}]/[${ClientPrefs.keyBinds.get('ui_left')[1]}] Left Movement | [${ClientPrefs.keyBinds.get('ui_right')[0]}]/[${ClientPrefs.keyBinds.get('ui_right')[1]}] Right movement | [${ClientPrefs.keyBinds.get('accept')[0]}]/[${ClientPrefs.keyBinds.get('accept')[1]}] Confirm selection'
        );
		var size:Int = 16;
		bottomText = new FlxText(bottomBG.x, bottomBG.y + 4, FlxG.width, leText, size);
		bottomText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), size, FlxColor.WHITE, CENTER);
		bottomText.scrollFactor.set();
        bottomText.y = 718;
        bottomText.antialiasing = ClientPrefs.data.antialiasing;
		add(bottomText);

        if (swagShader != null) {
			selectorTablet.shader = freeplayTablets.shader = bgImage.shader = freeplayTitle.shader = swagShader.shader;
		}

        doIntro();

        super.create();
    }
    
    var canSelectSomething:Bool = false;
    var canEnter:Bool = false;
    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (canSelectSomething) {
            if (controls.UI_LEFT_P || controls.UI_RIGHT_P) FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);

            if (controls.ACCEPT) {
                if (canEnter) {
                    sectionSelected = freeplaySections[curSelected];
                    FlxG.sound.play(Paths.sound('confirm'), 0.5);
                    FlxG.sound.music.fadeOut(0.5, 0);
                    MusicBeatState.switchState(new FreeplayState());
                } else FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
            }
    
            if (controls.BACK) {
                canEnter = false;
                canSelectSomething = false;
                doOutro();
            }
        }
    }

    function doIntro():Void {
        freeplayTablets.animation.play('intro', true);
        FlxTween.tween(titleBack, {y: 0}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(freeplayTitle, {y: 16}, 1.2, {ease: FlxEase.cubeOut});
        FlxTween.tween(bottomBG, {y: 694}, 1.2, {ease: FlxEase.cubeOut});
        FlxTween.tween(bottomText, {y: 698}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(selectorTablet, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.8, onComplete: function(twn:FlxTween) {
            canEnter = true;
            canSelectSomething = true;
            FlxG.sound.play(Paths.sound('freeplay/select'), 0.3);
        }});

        FlxTween.tween(logo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 1.2});
        FlxTween.tween(sectionSprite, {alpha: 1}, 0.35, {ease: FlxEase.cubeOut, startDelay: 1.2});
    }

    // Yeah, pretty functions names, right?
    function doOutro() {
        logo.alpha = 0;
        for (obj in [logo, sectionSprite, selectorTablet, bottomBG, bottomText]){
            FlxTween.cancelTweensOf(obj);
        }

        freeplayTablets.animation.play('intro', true, true);
        freeplayTablets.animation.finishCallback = function(name:String) {
            if (name == 'intro') freeplayTablets.alpha = 0;
        }

        FlxTween.tween(bgImage, {alpha: 0}, 0.6, {ease: FlxEase.cubeOut});
        FlxTween.tween(titleBack, {y: -150}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(freeplayTitle, {y: -100}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.3});

        for (obj in [sectionSprite, selectorTablet]){
            FlxTween.tween(obj, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.4});
        }

        FlxTween.tween(logo, {alpha: 0}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(bottomBG, {y: 754}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(bottomText, {y: 718}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});

        new FlxTimer().start(2.2, function(tmr:FlxTimer) {
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;

            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        });
    }
}