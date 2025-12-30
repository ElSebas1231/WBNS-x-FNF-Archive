package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.input.mouse.FlxMouseEventManager;

import options.OptionsState;
import states.freeplay.FreeplaySections;
import flixel.graphics.FlxGraphic;

enum MainMenuColumn {
	MAIN;
	NONE;
}

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.3'; // This is also used for Discord RPC
	public static var curColumn:MainMenuColumn = MAIN;
	public static var curSelected:Int = 0;
	var allowMouse:Bool = true;

	var mainBG:FlxSprite;
	var div:FlxSprite;
	var bottomBG:FlxSprite;
	var bottomText:FlxText;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var selectedItem:FlxSprite;

	var optionShit:Array<String> = [
		'freeplay',
		'credits',
		'options'
	];

	var blackTop:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		Cursor.show();
		if (curColumn != MAIN) curColumn = MAIN;

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.loadGraphic(Paths.image('ui/menus/utils/stars'));
		add(bg);

		var menuChance:Bool = FlxG.random.bool(30);
		mainBG = new FlxSprite(0, 0).loadGraphic(Paths.image(menuChance ? 'ui/menus/mainmenu/bg/menu_3' : 'ui/menus/mainmenu/bg/menu_${FlxG.random.int(1,2)}'));
		mainBG.antialiasing = ClientPrefs.data.antialiasing;
		mainBG.scrollFactor.set(0, 0);
		mainBG.screenCenter();
		mainBG.scale.set(1.2, 1.2);
		mainBG.alpha = 0;
		add(mainBG);
		
		FlxTween.tween(mainBG, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.6, {ease: FlxEase.quartOut});

		div = new FlxSprite(-200, 0);
		div.frames = Paths.getSparrowAtlas('ui/menus/mainmenu/bg/divicion_MenuPrincipal');
		div.antialiasing = ClientPrefs.data.antialiasing;
		div.animation.addByPrefix('idle', 'idle', 12);
		div.animation.play('idle');
		add(div);

		// INTRO ANIM 2
		div.x += -div.width;
		FlxTween.tween(div, {x: -200}, 1.3, {ease: FlxEase.quartOut, startDelay: 0.2});
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		for (i in 0...optionShit.length) {
			var menuItem:FlxSprite = new FlxSprite(0, 0);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = Paths.getSparrowAtlas('ui/menus/mainmenu/${optionShit[i]}');
			menuItem.animation.addByPrefix('idle', 'idle', 12);
			menuItem.animation.addByPrefix('selected', 'selected', 12);
			menuItem.animation.play('idle');
			menuItem.screenCenter();
			menuItem.x -= 300;
			menuItems.add(menuItem);

			var mouseMenuItems = new FlxMouseEventManager();
			mouseMenuItems.add(menuItem, onClick, onOut, onOver, onOut);
			add(mouseMenuItems);
		}
		
		positionMenuItems(true);

		/*
		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end
		*/

		bottomBG = new FlxSprite(0, 744).makeGraphic(FlxG.width, 26, 0xFF000000);
		FlxTween.tween(bottomBG, {alpha: 0.6, y: 694}, 1.6, {ease: FlxEase.cubeOut});
		add(bottomBG);

		var leText:String = Language.getPhrase(
            'freeplay_tip', 
            '[${ClientPrefs.keyBinds.get('ui_up')[0]}]/[${ClientPrefs.keyBinds.get('ui_up')[1]}]/[${ClientPrefs.keyBinds.get('ui_down')[0]}]/[${ClientPrefs.keyBinds.get('ui_down')[1]}]/[${ClientPrefs.keyBinds.get('ui_left')[0]}]/[${ClientPrefs.keyBinds.get('ui_left')[1]}]/[${ClientPrefs.keyBinds.get('ui_right')[0]}]/[${ClientPrefs.keyBinds.get('ui_right')[1]}] Movement | [${ClientPrefs.keyBinds.get('accept')[0]}]/[${ClientPrefs.keyBinds.get('accept')[1]}] or Left Mouse Click Confirm selection'
        );
		var size:Int = 16;
		bottomText = new FlxText(150, 748, FlxG.width, leText, size);
		bottomText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), size, FlxColor.WHITE, CENTER);
		bottomText.scrollFactor.set();
        bottomText.antialiasing = ClientPrefs.data.antialiasing;
		FlxTween.tween(bottomText, {y: 698}, 1.6, {ease: FlxEase.cubeOut});
		add(bottomText);

		blackTop = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
		blackTop.alpha = 0;
		add(blackTop);
		
		super.create();
	}

	var selectedSomethin:Bool = false;
	var canSelectSomething = false;
	var timeNotMoving:Float = 0;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if (FlxG.sound.music.volume < 0.8) {
			FlxG.sound.music.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin && canSelectSomething) {
			var allowMouse:Bool = allowMouse;
			if (allowMouse || FlxG.mouse.justMoved || FlxG.mouse.justPressed) {
				allowMouse = true;
				Cursor.show();
				timeNotMoving = 0;
			} else {
				timeNotMoving += elapsed;
				if (timeNotMoving > 2) Cursor.hide();
			}

			switch(curColumn) {
				case MAIN:
					if (controls.UI_UP_P) {
						changeItem(-shiftMult);
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					}
		
					if (controls.UI_DOWN_P) {
						changeItem(shiftMult);
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					}
		
					if (controls.UI_DOWN || controls.UI_UP) {
						var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
						holdTime += elapsed;
						var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
		
						if(holdTime > 0.5 && checkNewHold - checkLastHold > 0) {
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
							changeItem((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
						}
					}

					positionMenuItems(false);

				case NONE:
					if (controls.UI_UP_P) {
						changeItem(-shiftMult);
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					}
		
					if (controls.UI_DOWN_P) {
						changeItem(shiftMult);
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					}

					if (menuItems.members[curSelected].alpha == 1) menuItems.members[curSelected].alpha = 0.6;
			}

			if(FlxG.mouse.wheel != 0 && allowMouse && curColumn == MAIN) { 
				changeItem(-shiftMult * FlxG.mouse.wheel);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			}

			if (controls.BACK) {
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));

				if (selectedSomethin) {
					FlxTween.cancelTweensOf(mainBG);

					FlxTween.tween(div, {x: -1480}, 1.3, {ease: FlxEase.cubeOut, startDelay: 0.2});
					FlxTween.tween(mainBG, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.3, {ease: FlxEase.cubeOut});

					FlxTween.tween(bottomBG, {alpha: 0, y: 744}, 1.6, {ease: FlxEase.cubeOut});
					FlxTween.tween(bottomText, {alpha: 0, y: 748}, 1.6, {ease: FlxEase.cubeOut});
	
					for (i in 0...menuItems.length) {
						var menuItem = menuItems.members[i];
						var oX = menuItem.x - 850;
	
						menuItem.alpha = 0.6;
						FlxTween.cancelTweensOf(menuItem);
	
						if (i == 0)  {
							FlxTween.tween(menuItem, {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
							FlxTween.tween(menuItems.members[menuItems.length - 1], {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
						} else  {
							FlxTween.tween(menuItem, {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
						}
					}
	
					new FlxTimer().start(2.2, function(tmr:FlxTimer) {
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						TitleState.mainMenuBack = true;
						MusicBeatState.switchState(new TitleState());
					});
				}
			}

			if (controls.ACCEPT) {
				var option:String;
				switch(curColumn) {
					case MAIN:
						option = optionShit[curSelected];

					case NONE:
						option = null;
				}

				if (option != null) {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;
					menuMoveTo(optionShit[curSelected]);
				}
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		if(huh != 0) curColumn = MAIN;
		
		curSelected = FlxMath.wrap(curSelected + huh, 0, optionShit.length - 1);

		for (item in menuItems) {
			item.animation.play('idle');
			item.centerOffsets();
		}

		switch(curColumn) {
			case MAIN:
				selectedItem = menuItems.members[curSelected];
			case NONE:
				selectedItem = null;
		}
		
		if (selectedItem != null) {
			if (menuItems.members[curSelected] != null) {
				menuItems.members[curSelected].alpha = (curColumn == MAIN) ? 1 : 0.6;

				if (curColumn != MAIN) {
					menuItems.members[curSelected].animation.play('idle');
					menuItems.members[curSelected].centerOffsets();
				}
			}
			
			if (canSelectSomething) {
				selectedItem.animation.play('selected');
				selectedItem.centerOffsets();
			}
		}
	}

	function onOver(target:FlxSprite) {
		if (!selectedSomethin && canSelectSomething) {
			if (target == menuItems.members[curSelected]) {
				if (menuItems.members[curSelected] != null && curColumn == MAIN) {
					menuItems.members[curSelected].alpha = 1;
				} else {
					menuItems.members[curSelected].alpha = 0.6;
				}

				selectedItem = menuItems.members[curSelected];
				curColumn = MAIN;
				changeItem();
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			}
		}
	}

	function onOut(target:FlxSprite) {
		if (!selectedSomethin && canSelectSomething) {
			if (target == menuItems.members[curSelected]) {
				if (menuItems.members[curSelected] != null && curColumn == MAIN) {
					menuItems.members[curSelected].alpha = 0.6;
					menuItems.members[curSelected].animation.play('idle');
					menuItems.members[curSelected].centerOffsets();
				} 

				selectedSomethin = false;
				canSelectSomething = true;
				curColumn = NONE;
			}
		}
	}

	function onClick(target:FlxSprite) {
		if (!selectedSomethin && canSelectSomething) {
			if (target == menuItems.members[curSelected]) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				canSelectSomething = false;
				menuMoveTo(optionShit[curSelected]);
			}
		}
	}

	function positionMenuItems(intro:Bool) {
		for (i in 0...menuItems.length) {
			var menuItem = menuItems.members[i];
			var offset:Float = FlxG.height / 2 - 350;
			var indexOffset = (i - curSelected + menuItems.length) % menuItems.length;
			
			menuItem.y = (indexOffset * 180) + offset;

			menuItem.alpha = (i == curSelected && canSelectSomething) ? 1 : 0.6;
	
			// Ensure the previous item is also visible
			if (indexOffset == menuItems.length - 1) {
				menuItem.y = (-1 * 180) + offset;
				menuItem.alpha = 0.6;
			}

			if (intro) {
				var oX = menuItem.x;
				
				menuItem.x += -800;
				
				FlxTween.cancelTweensOf(menuItems);
	
				if (i == 0)  {
					FlxTween.tween(menuItems.members[menuItems.length - 1], {x: oX}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.2 + (0.1 * i)});
					FlxTween.tween(menuItem, {x: oX}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.3 + (0.1 * i)});
				} else {
					FlxTween.tween(menuItem, {x: oX}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.3 + (0.1 * i)});
				}
	
				new FlxTimer().start(1.8, function(tmr:FlxTimer) {
					canSelectSomething = true;
					changeItem();
				});
			}
		}
	}

	function transition(state:Dynamic)
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.4}, 1.3, {ease: FlxEase.smoothStepIn, onComplete: function(t:FlxTween)
		{
			new FlxTimer().start(0.4, function(t:FlxTimer)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				MusicBeatState.switchState(state);
			});
		}});

		FlxTween.tween(blackTop, {alpha: 1}, 1.15, {ease: FlxEase.smoothStepIn});
	}

	function menuMoveTo(option:String) {
		switch (option) {
			case 'freeplay':
				transition(new FreeplaySections());
			case 'options':
				OptionsState.onPlayState = false;
				if (PlayState.SONG != null) {
					PlayState.SONG.arrowSkin = null;
					PlayState.SONG.splashSkin = null;
					PlayState.stageUI = 'normal';
				}

				transition(new OptionsState());

			case 'credits':
				transition(new CreditsState());

			default:
				// Nothing..........
		}
	}
}