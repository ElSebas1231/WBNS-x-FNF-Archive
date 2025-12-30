package states.freeplay;

import openfl.Assets;
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
    var dlcLogo:FlxSprite;
    var selectorTablet:FlxSprite;
    var freeplayTitle:FlxSprite;
    var titleBack:FlxSprite;
    var arrowSelection1Tween:FlxTween;
    var arrowSelection2Tween:FlxTween;

    private static var curSelected:Int = 0;
    public static var sectionSelected:String = '';
    public static var freeplaySections:Array<String> = ['c3jodlc', 'aquinodlc']; 

	var bottomText:FlxText;
	var bottomBG:FlxSprite;

    var messageOverlay:FlxSprite;
    var messageText:FlxText;
    var showMessage:Bool = false;
    var onMessageClose:Void->Void = null;

    override function create():Void {
        Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

        openfl.Lib.application.window.setIcon(lime.graphics.Image.fromFile('assets/shared/images/ui/menus/utils/icon.png'));

        if (FlxG.mouse.visible) Cursor.hide();
        
        if (FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('freakyMenu'));
        
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

        dlcLogo = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
        dlcLogo.antialiasing = ClientPrefs.data.antialiasing;
        dlcLogo.scale.set(0.75, 0.75);
        dlcLogo.updateHitbox();
        dlcLogo.x = 430;
        dlcLogo.y = 100;
        add(dlcLogo);
        
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

        openfl.Lib.application.window.setIcon(lime.graphics.Image.fromFile('assets/shared/images/ui/menus/utils/icon.png'));

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
                } else {
                    FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
                }
            } else if (controls.UI_RIGHT_P) {
                if (freeplaySections.length > 1) {
                    changeSelection(1);

                    if(arrowSelection2Tween != null) arrowSelection2Tween.cancel();

                    arrowSelector2.scale.set(1.45, 1.45);
                    arrowSelection2Tween = FlxTween.tween(arrowSelector2.scale, {x: 1.2, y: 1.2}, 0.2, {
                        onComplete: function(twn:FlxTween) {
                            arrowSelection2Tween = null;
                        }
                    });
                } else {
                    FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
                }
            }

            if (controls.ACCEPT) {
                if (canEnter) {
                    sectionSelected = freeplaySections[curSelected];
                    if (sectionSelected == "c3jodlc") {
                        var texto:String = Assets.getText(Paths.txt("mensajeC3jo")).replace("\\n", "\n");
                        canSelectSomething = false;
                        showOneTimeMessage('mensajeC3jo', '$texto\n\n¡Presiona ${ClientPrefs.keyBinds.get('back')[0]} ó ${ClientPrefs.keyBinds.get('back')[1]} para quitar este mensaje e ir al selector de canciones!\nNota: Este mensaje no volverá a aparecer', function() {
                            FlxG.sound.play(Paths.sound('confirm'), 0.5);
                            MusicBeatState.switchState(new FreeplayState());
                        });
                    }

                    if (sectionSelected == "aquinodlc") {
                        var texto:String = Assets.getText(Paths.txt("mensajeAquino")).replace("\\n", "\n");
                        canSelectSomething = false;
                        showOneTimeMessage('mensajeAquino', '$texto\n\n¡Presiona ${ClientPrefs.keyBinds.get('back')[0]} ó ${ClientPrefs.keyBinds.get('back')[1]} para quitar este mensaje e ir al selector de canciones!\nNota: Este mensaje no volverá a aparecer', function() {
                            FlxG.sound.play(Paths.sound('confirm'), 0.5);
                            MusicBeatState.switchState(new FreeplayState());
                        });
                    }

                    if (!showMessage) {
                        FlxG.sound.play(Paths.sound('confirm'), 0.5);
                        MusicBeatState.switchState(new FreeplayState());
                    }
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

        if (controls.BACK) {
            if (showMessage && !canSelectSomething) {
                hideOverlayMessage();
            }
        }
    }

    function tryUnlockSection(section:String, messageId:String, message:String, finishCallback:Void->Void) {
        if (!ClientPrefs.data.fpSectionsUnlocked.contains(section)) {
            doUnlockCinematic(section, messageId, message, finishCallback);
            return true;
        }
        return false;
    }

    function doIntro():Void {
        freeplayTablets.animation.play('intro', true);
        FlxTween.tween(titleBack, {y: 0}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(freeplayTitle, {y: 16}, 1.2, {ease: FlxEase.cubeOut});
        FlxTween.tween(bottomBG, {y: 694}, 1.2, {ease: FlxEase.cubeOut});
        FlxTween.tween(bottomText, {y: 698}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});

        FlxTween.tween(selectorTablet, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.8});
        FlxTween.tween(arrowSelector1, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.8});
        FlxTween.tween(arrowSelector2, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.8});

        new FlxTimer().start(1.5, function(tmr:FlxTimer) {
            var unlocked = tryUnlockSection(
                'c3jodlc',
                'unlockC3joDLC',
                '¡Felicidades!\nSe has desbloqueado el DLC de C3jo\nMuchas gracias por descargar el mod, disfruta del nuevo contenido.\n\nPresiona ${ClientPrefs.keyBinds.get('back')[0]} ó ${ClientPrefs.keyBinds.get('back')[1]} para quitar este mensaje\nNota: Este mensaje no volverá a aparecer',
                function() {
                    canEnter = true;
                    onMessageClose = null;
                    canSelectSomething = true;
                    canDoCinematic = true;

                    // Intentar desbloquear aquinodlc después de c3jodlc
                    tryUnlockSection(
                        'aquinodlc',
                        'unlockAquinoDLC',
                        '¡Felicidades!\nSe has desbloqueado el DLC de Aquino\nMuchas gracias por descargar el mod, disfruta del nuevo contenido.\n\nPresiona ${ClientPrefs.keyBinds.get('back')[0]} ó ${ClientPrefs.keyBinds.get('back')[1]} para quitar este mensaje\nNota: Este mensaje no volverá a aparecer',
                        function() {
                            canEnter = true;
                            canSelectSomething = true;
                            canDoCinematic = true;
                        }
                    );
                }
            );

            if (!unlocked) {
                tryUnlockSection(
                    'aquinodlc',
                    'unlockAquinoDLC',
                    '¡Felicidades!\nSe has desbloqueado el DLC de Aquino\nMuchas gracias por descargar el mod, disfruta del nuevo contenido.\n\nPresiona ${ClientPrefs.keyBinds.get('back')[0]} ó ${ClientPrefs.keyBinds.get('back')[1]} para quitar este mensaje\nNota: Este mensaje no volverá a aparecer',
                    function() {
                        canEnter = true;
                        canSelectSomething = true;
                        canDoCinematic = true;
                    }
                );
            }

            if (ClientPrefs.data.fpSectionsUnlocked.contains('c3jodlc') && ClientPrefs.data.fpSectionsUnlocked.contains('aquinodlc')) {
                canSelectSomething = true;
            }
        });
    }

    // Yeah, pretty functions names, right?
    function doOutro() {
        FlxTween.cancelTweensOf(lockSprite);
        FlxTween.cancelTweensOf(dlcLogo);
        lockSprite.alpha = 0;
        dlcLogo.alpha = 0;

        freeplayTablets.animation.play('intro', true, true);
        freeplayTablets.animation.finishCallback = function(name:String) {
            if (name == 'intro') freeplayTablets.alpha = 0;
        }

        FlxTween.tween(bgImage, {alpha: 0}, 0.6, {ease: FlxEase.cubeOut});
        FlxTween.tween(titleBack, {y: -150}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.2});
        FlxTween.tween(freeplayTitle, {y: -100}, 0.8, {ease: FlxEase.cubeOut, startDelay: 0.3});

        FlxTween.cancelTweensOf(sectionSprite);
        FlxTween.cancelTweensOf(selectorTablet);
        FlxTween.cancelTweensOf(arrowSelector1);
        FlxTween.cancelTweensOf(arrowSelector2);
        FlxTween.cancelTweensOf(bottomBG);
        FlxTween.cancelTweensOf(bottomText);
        
        FlxTween.tween(sectionSprite, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.4});
        FlxTween.tween(selectorTablet, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.4});
        FlxTween.tween(arrowSelector1, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.4});
        FlxTween.tween(arrowSelector2, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.4});
        FlxTween.tween(dlcLogo, {alpha: 0}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});
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

    // Make sure to have some assets related with the unlocked section, just saying...
    // I know... this sucks...
    var canDoCinematic:Bool = true;
    var tweenSectionSprCinematic:FlxTween;
    function doUnlockCinematic(sectionUnlocked:String, messageId:String, message:String, finishCallBack:Void->Void) {
        if (canDoCinematic) {
            canDoCinematic = false;
            if (canSelectSomething) canSelectSomething = false;
    
            FlxTween.cancelTweensOf(dlcLogo);
            FlxTween.cancelTweensOf(sectionSprite);
            
            dlcLogo.alpha = 0;
            sectionSprite.alpha = 0;
            
            FlxG.sound.play(Paths.sound('freeplay/select'), 0.3);
            freeplayTablets.animation.play('turn', true);
            freeplayTablets.animation.finishCallback = function(name:String) {
                if (name == 'turn') {
                    freeplayTablets.animation.play('idle');
                    lockSprite.alpha = 1;
                }
            }
    
            if (Paths.fileExists('images/ui/menus/freeplay/tab/${sectionUnlocked}_logo.png', IMAGE)) {
                dlcLogo.loadGraphic(Paths.image('ui/menus/freeplay/tab/${sectionUnlocked}_logo'));
            } else {
                dlcLogo.loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
            }
            dlcLogo.updateHitbox();
            dlcLogo.x = 430;
            dlcLogo.y = 100;
            FlxTween.tween(dlcLogo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});
            
            sectionSprite.alpha = 0;
            sectionSprite.loadGraphic(Paths.image('ui/menus/freeplay/tab/sec_${sectionUnlocked}'));
    
            if (tweenSectionSprCinematic != null) tweenSectionSprCinematic.cancel();
            tweenSectionSprCinematic = FlxTween.tween(sectionSprite, {alpha: 1}, 0.35, {onComplete: function(twn:FlxTween) {
                tweenSectionSpr = null;
    
                lockSprite.animation.play('press');
                lockSprite.animation.finishCallback = function(name:String) {
                    if (name == 'press') {
                        lockSprite.animation.play('idle');
                        FlxTween.cancelTweensOf(lockSprite);
                        FlxTween.tween(lockSprite, {alpha: 0}, 0.45, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
                            if ((!ClientPrefs.data.messagesAlreadySeen.exists(messageId) || !ClientPrefs.data.messagesAlreadySeen.get(messageId))) {
                                showOneTimeMessage(messageId, message, function() {
                                    onMessageClose = null;
                                    if (finishCallBack != null) finishCallBack();
                                });
                            } else {
                                if (finishCallBack != null) finishCallBack();
                            }
                        }});
                        
                        ClientPrefs.data.fpSectionsUnlocked.push(sectionUnlocked);
                        curSelected = ClientPrefs.data.fpSectionsUnlocked.indexOf(sectionUnlocked);
                    }
                }
            }});
        }
    }

    // Messages stuff
    function showOverlayMessage(msg:String) {
        if (!showMessage) {
            showMessage = true;

            messageOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            messageOverlay.alpha = 0.6;
            messageOverlay.scale.set(0.2, 0.2);
            messageOverlay.updateHitbox();
            messageOverlay.screenCenter();
            messageOverlay.scrollFactor.set();
            add(messageOverlay);
        
            messageText = new FlxText(0, 0, FlxG.width - 100, msg, 28);
            messageText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            messageText.scrollFactor.set();
            messageText.borderSize = 2;
            messageText.antialiasing = ClientPrefs.data.antialiasing;
            messageText.alpha = 0.0001;
            messageText.screenCenter();
            add(messageText);

            FlxTween.tween(messageOverlay, {"scale.x": 1, "scale.y": 1}, 0.4, {ease: FlxEase.smoothStepIn, onComplete: function(t:FlxTween) {
                FlxTween.tween(messageText, {alpha: 1}, 0.2, {ease: FlxEase.smoothStepIn});
            }});
        }
    }

    function hideOverlayMessage() {
        if (messageText != null) FlxTween.tween(messageText, {alpha: 0.0001}, 0.4, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween) {
            if (messageOverlay != null) FlxTween.tween(messageOverlay, {"scale.x": 0.2, "scale.y": 0.2}, 0.4, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween) {
                showMessage = false;
                remove(messageOverlay, true);
                remove(messageText, true);

                if (onMessageClose != null) {
                    onMessageClose();
                    onMessageClose = null;
                }
            }});
        }});
    }

    function showOneTimeMessage(id:String, texto:String, ?closeCallback:Void->Void) {
        if (!ClientPrefs.data.messagesAlreadySeen.exists(id) || !ClientPrefs.data.messagesAlreadySeen.get(id)) {
            showOverlayMessage(texto);
            onMessageClose = closeCallback;

            ClientPrefs.data.messagesAlreadySeen.set(id, true);
            ClientPrefs.saveSettings();
        }
    }
    // end of messages stuff

    var tweenSectionSpr:FlxTween;
    function changeSelection(change:Int = 0, ?intro:Bool = false) {
        curSelected += change;

        if (curSelected < 0) curSelected = freeplaySections.length-1;
        if (curSelected >= freeplaySections.length) curSelected = 0;

        if (change >= 1)
            freeplayTablets.animation.play('turn', true);
        else if (change <= 1)
            freeplayTablets.animation.play('turn inv', true);

        canEnter = false;
        canSelectSomething = false;

        FlxTween.cancelTweensOf(lockSprite);
        FlxTween.cancelTweensOf(dlcLogo);
        FlxTween.cancelTweensOf(sectionSprite);
        lockSprite.alpha = 0;
        dlcLogo.alpha = 0;
        sectionSprite.alpha = 0;

        if (!intro) {
            FlxG.sound.play(Paths.sound('freeplay/select'), 0.3);
            if (ClientPrefs.data.fpSectionsUnlocked.contains(freeplaySections[curSelected])) {
                freeplayTablets.animation.finishCallback = function(name:String) {
                    if (name == 'turn' || name == 'turn inv')  {
                        freeplayTablets.animation.play('idle');
                    }
                }
                
                dlcLogo.alpha = 0;
                if (Paths.fileExists('images/ui/menus/freeplay/tab/${freeplaySections[curSelected]}_logo.png', IMAGE)) {
                    dlcLogo.loadGraphic(Paths.image('ui/menus/freeplay/tab/${freeplaySections[curSelected]}_logo'));
                } else {
                    dlcLogo.loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
                }
                dlcLogo.updateHitbox();
                dlcLogo.x = 430;
                dlcLogo.y = 100;
                FlxTween.tween(dlcLogo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});

                sectionSprite.alpha = 0;
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

                dlcLogo.alpha = 0;
                dlcLogo.loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
                dlcLogo.updateHitbox();
                dlcLogo.x = 430;
                dlcLogo.y = 100;
                FlxTween.tween(dlcLogo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 0.2});

                sectionSprite.alpha = 0;
                sectionSprite.loadGraphic(Paths.image('ui/menus/freeplay/tab/padlock'));
    
                if (tweenSectionSpr != null) tweenSectionSpr.cancel();
                tweenSectionSpr = FlxTween.tween(sectionSprite, {alpha: 1}, 0.35, {onComplete: function(twn:FlxTween)
                {
                    tweenSectionSpr = null;
                }});
            }
        } else {
            dlcLogo.alpha = 0;
            if (Paths.fileExists('images/ui/menus/freeplay/tab/${freeplaySections[curSelected]}_logo.png', IMAGE)) {
                dlcLogo.loadGraphic(Paths.image('ui/menus/freeplay/tab/${freeplaySections[curSelected]}_logo'));
            } else {
                dlcLogo.loadGraphic(Paths.image('ui/menus/freeplay/tab/wbns_logo'));
            }
            dlcLogo.x = 430;
            dlcLogo.y = 100;
            FlxTween.tween(dlcLogo, {alpha: 1}, 0.65, {ease: FlxEase.cubeOut, startDelay: 1.5});

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