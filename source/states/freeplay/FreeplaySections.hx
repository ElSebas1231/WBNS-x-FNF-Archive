package states.freeplay;

import flixel.graphics.FlxGraphic;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

class FreeplaySections extends MusicBeatState {
    var bgImage:FlxSprite;
    var freeplayTablets:FlxSprite;
    var arrowSelector1:FlxSprite;
    var arrowSelector2:FlxSprite;
    var lockSprite:FlxSprite;

    var sectionSprite:FlxSprite;
    var logo:FlxSprite;
    var selectorTablet:FlxSprite;
    var freeplayTitle:FlxSprite;
    var titleBack:FlxSprite;
    var arrowSelection1Tween:FlxTween;
    var arrowSelection2Tween:FlxTween;

    private static var curSelected:Int = 0;
    public static var sectionSelected:String = '';
    public static var freeplaySections:Array<String> = ['storymode', 'extras', 'remixes']; 

    var bottomText:FlxText;
	var bottomBG:FlxSprite;

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

        for (item in ClientPrefs.data.fpSectionsUnlocked) {
            if (!freeplaySections.contains(item)) {
                freeplaySections.push(item);
            }
        }

		var bgColor:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF121227);
		add(bgColor);

		var bgStars:FlxSprite = new FlxSprite();
		bgStars.antialiasing = ClientPrefs.data.antialiasing;
		bgStars.loadGraphic(Paths.image('ui/menus/utils/stars'));
		add(bgStars);

        bgImage = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/space_background'));
        bgImage.antialiasing = ClientPrefs.data.antialiasing;
        bgImage.screenCenter();
        add(bgImage);

        var grid:FlxBackdrop = new FlxBackdrop(Paths.image('ui/menus/titlemenu/checker'));
		grid.x = TitleState.gridXPosition;
		grid.y = TitleState.gridYPosition;
		grid.scale.set(0.3, 0.3);
		grid.velocity.set(40, -40);
		grid.alpha = 0.45;
		add(grid);

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

        logo = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
        logo.antialiasing = ClientPrefs.data.antialiasing;
        logo.scale.set(0.75, 0.75);
        logo.updateHitbox();
        logo.x = 430;
        logo.y = 100;
        add(logo);
        
        lockSprite = new FlxSprite(0, 0);
        lockSprite.antialiasing = ClientPrefs.data.antialiasing;
        lockSprite.frames = Paths.getSparrowAtlas('ui/menus/freeplay/tab/pixel padlock');
        lockSprite.animation.addByPrefix('idle', 'pixel padlock padlock idle0', 24, true);
        lockSprite.animation.addByPrefix('press', 'pixel padlock padlock press0', 24, false);
        lockSprite.animation.finishCallback = function(name:String) {
            if (name == 'press') freeplayTablets.animation.play('idle');
        }
        lockSprite.screenCenter();
        lockSprite.y -= 30;
        lockSprite.alpha = 0;
        add(lockSprite);

        selectorTablet = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/title tablet selector'));
        selectorTablet.antialiasing = ClientPrefs.data.antialiasing;
        selectorTablet.screenCenter();
        selectorTablet.y += 260;
        selectorTablet.alpha = 0;
        selectorTablet.scale.set(1.2, 1.2);
        add(selectorTablet);

        sectionSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/padlock'));
        sectionSprite.screenCenter();
        sectionSprite.y += 260;
        sectionSprite.alpha = 0;
        sectionSprite.antialiasing = ClientPrefs.data.antialiasing;
        add(sectionSprite);

        arrowSelector1 = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/arrow'));
        arrowSelector1.antialiasing = ClientPrefs.data.antialiasing;
        arrowSelector1.alpha = 0;
        arrowSelector1.scale.set(1.2, 1.2);
        arrowSelector1.x = selectorTablet.x - 120;
        arrowSelector1.y = selectorTablet.y - 40;
        add(arrowSelector1);

        arrowSelector2 = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/arrow'));
        arrowSelector2.antialiasing = ClientPrefs.data.antialiasing;
        arrowSelector2.flipX = true;
        arrowSelector2.alpha = 0;
        arrowSelector2.scale.set(1.2, 1.2);
        arrowSelector2.x = selectorTablet.x + 380;
        arrowSelector2.y = arrowSelector1.y;
        add(arrowSelector2);

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

        changeSelection(0, true);
        doIntro();

        super.create();
    }
    
    var movedBack:Bool = false;
    var canSelectSomething:Bool = false;
    var canEnter:Bool = false;
    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (canSelectSomething) {
            if (controls.UI_LEFT_P) {
                if (freeplaySections.length > 1) {
                    changeSelection(-1);
                    if(arrowSelection1Tween != null) arrowSelection1Tween.cancel();

                    arrowSelector1.scale.set(1.45, 1.45);
                    arrowSelection1Tween = FlxTween.tween(arrowSelector1.scale, {x: 1.2, y: 1.2}, 0.2, {
                        onComplete: function(twn:FlxTween) {
                            arrowSelection1Tween = null;
                        }
                    });
                } else FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
            } 
            
            if (controls.UI_RIGHT_P) {
                if (freeplaySections.length > 1) {
                    changeSelection(1);

                    if(arrowSelection2Tween != null) arrowSelection2Tween.cancel();

                    arrowSelector2.scale.set(1.45, 1.45);
                    arrowSelection2Tween = FlxTween.tween(arrowSelector2.scale, {x: 1.2, y: 1.2}, 0.2, {
                        onComplete: function(twn:FlxTween) {
                            arrowSelection2Tween = null;
                        }
                    });
                } else FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
            }

            if (controls.ACCEPT) {
                if (canEnter) {
                    sectionSelected = freeplaySections[curSelected];
                    FlxG.sound.play(Paths.sound('confirm'), 0.5);
                    FlxG.sound.music.fadeOut(0.5, 0);
                    MusicBeatState.switchState(new FreeplayState());
                } else {
                    FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
                    freeplayTablets.animation.play('lock pressed');
                    lockSprite.animation.play('press');
                    lockSprite.animation.finishCallback = function(name:String) {
                        if (name == 'press') lockSprite.animation.play('idle');
                    }
                }
            }
    
            if (controls.BACK) {
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

        for (obj in [selectorTablet, arrowSelector1, arrowSelector2]){
            FlxTween.tween(obj, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.8});
        }

        new FlxTimer().start(1.5, function(tmr:FlxTimer) {
            FlxG.sound.play(Paths.sound('freeplay/select'), 0.3, false, null, true, function() {
                canSelectSomething = true;
            });
        });
    }

    // Yeah, pretty functions names, right?
    function doOutro() {
        for (obj in [lockSprite, logo, sectionSprite, selectorTablet, arrowSelector1, arrowSelector2, bottomBG, bottomText]){
            FlxTween.cancelTweensOf(obj);
        }

        lockSprite.alpha = 0;
        logo.alpha = 0;

        freeplayTablets.animation.play('intro', true, true);
        freeplayTablets.animation.finishCallback = function(name:String) {
            if (name == 'intro') freeplayTablets.alpha = 0;
        }

        FlxTween.tween(bgImage, {alpha: 0}, 0.6, {ease: FlxEase.cubeOut});
        FlxTween.tween(titleBack, {y: -150}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(freeplayTitle, {y: -100}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.3});

        for (obj in [sectionSprite, selectorTablet, arrowSelector1, arrowSelector2]){
            FlxTween.tween(obj, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.4});
        }

        FlxTween.tween(logo, {alpha: 0}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(bottomBG, {y: 754}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(bottomText, {y: 718}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});

        new FlxTimer().start(2.2, function(tmr:FlxTimer) {
            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;
            FlxG.sound.play(Paths.sound('cancelMenu'));
            movedBack = true;
            MusicBeatState.switchState(new MainMenuState());
        });
    }

    var tweenSectionSpr:FlxTween;
    function changeSelection(change:Int = 0, ?intro:Bool = false) {
        curSelected += change;

        if (curSelected < 0) curSelected = freeplaySections.length-1;
        if (curSelected >= freeplaySections.length) curSelected = 0;

        if (freeplaySections[curSelected].contains('dlc')) sectionSelected = freeplaySections[curSelected]; else sectionSelected = '';

        if (change >= 1)
            freeplayTablets.animation.play('turn', true);
        else if (change <= 1)
            freeplayTablets.animation.play('turn inv', true);

        canEnter = false;
        canSelectSomething = false;

        for (obj in [lockSprite, logo, sectionSprite]){
            FlxTween.cancelTweensOf(obj);
        }
        
        lockSprite.alpha = 0;
        logo.alpha = 0;
        sectionSprite.alpha = 0;

        if (!intro) {
            FlxG.sound.play(Paths.sound('freeplay/select'), 0.3);
            if (ClientPrefs.data.fpSectionsUnlocked.contains(freeplaySections[curSelected])) {
                freeplayTablets.animation.finishCallback = function(name:String) {
                    if (name == 'turn' || name == 'turn inv')  {
                        freeplayTablets.animation.play('idle');
                    }
                }
                
                logo.alpha = 0;
                if (freeplaySections[curSelected].contains('dlc')) {
                    logo.loadGraphic(Paths.image('freeplay/dlc_logo'));
                } else {
                    if (Paths.fileExists('images/ui/menus/freeplay/tab/${freeplaySections[curSelected]}_logo.png', IMAGE)) {
                        logo.loadGraphic(Paths.image('ui/menus/freeplay/tab/${freeplaySections[curSelected]}_logo'));
                    } else {
                        logo.loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
                    }
                }
                
                logo.updateHitbox();
                logo.x = 430;
                logo.y = 100;
                FlxTween.tween(logo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});

                sectionSprite.alpha = 0;
                
                if (freeplaySections[curSelected].contains('dlc'))
                    sectionSprite.loadGraphic(Paths.image('freeplay/sec_dlc'));
                else 
                    sectionSprite.loadGraphic(Paths.image('ui/menus/freeplay/tab/sec_${freeplaySections[curSelected]}'));
    
                if (tweenSectionSpr != null) tweenSectionSpr.cancel();
                tweenSectionSpr = FlxTween.tween(sectionSprite, {alpha: 1}, 0.35, {onComplete: function(twn:FlxTween) {
                    canEnter = true;
                    tweenSectionSpr = null;
                }});
            } else {
                canEnter = false;
                freeplayTablets.animation.finishCallback = function(name:String) {
                    if (name == 'turn' || name == 'turn inv')  {
                        FlxTween.cancelTweensOf(lockSprite);
                        FlxTween.tween(lockSprite, {alpha: 1}, 0.45, {ease: FlxEase.cubeOut});
                        freeplayTablets.animation.play('idle');
                    }
                }

                logo.alpha = 0;
                logo.loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
                logo.updateHitbox();
                logo.x = 430;
                logo.y = 100;
                FlxTween.tween(logo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});

                sectionSprite.alpha = 0;
                sectionSprite.loadGraphic(Paths.image('ui/menus/freeplay/tab/padlock'));
    
                if (tweenSectionSpr != null) tweenSectionSpr.cancel();
                tweenSectionSpr = FlxTween.tween(sectionSprite, {alpha: 1}, 0.35, {onComplete: function(twn:FlxTween)
                {
                    tweenSectionSpr = null;
                }});
            }
        } else {
            logo.alpha = 0;
            if (freeplaySections[curSelected].contains('dlc')) {
                logo.loadGraphic(Paths.image('freeplay/dlc_logo'));
            } else {
                if (Paths.fileExists('freeplay/tab/${freeplaySections[curSelected]}_logo.png', IMAGE)) {
                    logo.loadGraphic(Paths.image('ui/menus/freeplay/tab/${freeplaySections[curSelected]}_logo'));
                } else {
                    logo.loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
                }
            }
            logo.x = 430;
            logo.y = 100;
            FlxTween.tween(logo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 1.5});

            if (freeplaySections[curSelected].contains('dlc'))
                sectionSprite.loadGraphic(Paths.image('freeplay/sec_dlc'));
            else 
                sectionSprite.loadGraphic(Paths.image('ui/menus/freeplay/tab/sec_${freeplaySections[curSelected]}'));
        }

        new FlxTimer().start(0.5, function(tmr:FlxTimer) {
            canSelectSomething = true;
            FlxTween.tween(sectionSprite, {alpha: 1}, 1.4, {ease: FlxEase.cubeOut, startDelay: 1.2, onComplete: function(twn:FlxTween) {
                if (intro && ClientPrefs.data.fpSectionsUnlocked.contains(freeplaySections[curSelected])) canEnter = true;
            }});
        });
    }
}