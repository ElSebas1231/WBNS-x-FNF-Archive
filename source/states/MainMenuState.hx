package states;

import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.input.mouse.FlxMouseEventManager;

import states.editors.MasterEditorMenu;
import options.OptionsState;
import states.freeplay.FreeplaySections;
import flixel.graphics.FlxGraphic;
import states.shop.ShopState;

enum MainMenuColumn {
	DLC;
	MAIN;
	SHOP;
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
	var lockItems:FlxTypedGroup<FlxSprite>;
	var dlcItem:FlxSprite;
	var lockSpriteDLC:FlxSprite;
	var lockSpriteShop:FlxSprite;
	var shopItem:FlxSprite;
	var selectedItem:FlxSprite;

	var optionShit:Array<String> = [
		'storymode',
		'freeplay',
		'achievements',
		'gallery',
		'credits',
		'options'
	];

	var optionsBlocked:Array<String> = [
		/*
		'storymode',
		'achievements',
		'gallery',
		'dlcs',
		'shop'
		*/
	];

	var dlcOption:String = 'dlcs';
	var shopOption:String = 'shop';
	var grid:FlxBackdrop;
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

		var bgColor:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF121227);
		add(bgColor);

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.loadGraphic(Paths.image('ui/menus/utils/stars'));
		add(bg);

		grid = new FlxBackdrop(Paths.image('ui/menus/titlemenu/checker'));
		grid.x = TitleState.gridXPosition;
		grid.y = TitleState.gridYPosition;
		grid.scale.set(0.3, 0.3);
		grid.velocity.set(40, -40);
		grid.alpha = 0.45;
		add(grid);

		mainBG = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/mainmenu/bg/menu_background'));
		mainBG.antialiasing = ClientPrefs.data.antialiasing;
		mainBG.scrollFactor.set(0, 0);
		mainBG.screenCenter();
		add(mainBG);

		mainBG.scale.set(1.2, 1.2);
		mainBG.alpha = 0;
		
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

		lockItems = new FlxTypedGroup<FlxSprite>();
		add(lockItems);
		
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

			if (optionsBlocked.contains(optionShit[i])) {
				var lockSprite = new FlxSprite().loadGraphic(Paths.image('ui/menus/utils/candado'));
				lockSprite.scale.set(0.5, 0.5);
				lockSprite.alpha = menuItem.alpha;
				lockSprite.antialiasing = ClientPrefs.data.antialiasing;
				lockSprite.x += 250;
				lockItems.add(lockSprite);
			}

			var mouseMenuItems = new FlxMouseEventManager();
			mouseMenuItems.add(menuItem, onClick, onOut, onOver, onOut);
			add(mouseMenuItems);
		}

		if (dlcOption != null) {
			dlcItem = new FlxSprite(930, -120);
			dlcItem.antialiasing = ClientPrefs.data.antialiasing;
			dlcItem.frames = Paths.getSparrowAtlas('ui/menus/mainmenu/dlcs');
			dlcItem.animation.addByPrefix('idle', 'idle', 12);
			dlcItem.animation.addByPrefix('selected', 'selected', 12);
			dlcItem.animation.play('idle');
			dlcItem.scale.set(0.6, 0.6);
			dlcItem.updateHitbox();
			add(dlcItem);

			lockSpriteDLC = new FlxSprite().loadGraphic(Paths.image('ui/menus/utils/candado'));
			lockSpriteDLC.scale.set(0.5, 0.5);
			lockSpriteDLC.x = 1050;
			lockSpriteDLC.y = -30;
			lockSpriteDLC.visible = false;
			lockSpriteDLC.antialiasing = ClientPrefs.data.antialiasing;
			add(lockSpriteDLC);

			dlcItem.y = -320;
			lockSpriteDLC.y = -320;
			FlxTween.tween(dlcItem, {y: -120}, 1.6, {ease: FlxEase.quartOut, startDelay: 0.3});
			FlxTween.tween(lockSpriteDLC, {y: -30}, 1.6, {ease: FlxEase.quartOut, startDelay: 0.3});

			var mouseDLC = new FlxMouseEventManager();
			mouseDLC.add(dlcItem, onClick, onOut, onOver, onOut);
			add(mouseDLC);
		}

		if (shopOption != null) {
			shopItem = new FlxSprite(700, 450);
			shopItem.antialiasing = ClientPrefs.data.antialiasing;
			shopItem.frames = Paths.getSparrowAtlas('ui/menus/mainmenu/shop');
			shopItem.animation.addByPrefix('idle', 'idle', 12);
			shopItem.animation.addByPrefix('selected', 'selected', 12);
			shopItem.animation.play('idle');
			shopItem.scale.set(0.6, 0.6);
			shopItem.updateHitbox();
			add(shopItem);

			lockSpriteShop = new FlxSprite().loadGraphic(Paths.image('ui/menus/utils/candado'));
			lockSpriteShop.scale.set(0.5, 0.5);
			lockSpriteShop.x = 780;
			lockSpriteShop.y = 540;
			lockSpriteShop.visible = false;
			lockSpriteShop.antialiasing = ClientPrefs.data.antialiasing;
			add(lockSpriteShop);

			shopItem.x += 600;
			lockSpriteShop.x += 600;
			FlxTween.tween(lockSpriteShop, {x: 780}, 1.6, {ease: FlxEase.quartOut, startDelay: 0.3});
			FlxTween.tween(shopItem, {x: 700}, 1.6, {ease: FlxEase.quartOut, startDelay: 0.3});

			var mouseShop = new FlxMouseEventManager();
			mouseShop.add(shopItem, onClick, onOut, onOver, onOut);
			add(mouseShop);
		}

		if (dlcItem != null) dlcItem.alpha = (curColumn == DLC) ? 1 : 0.6;
		if (shopItem != null) shopItem.alpha = (curColumn == SHOP) ? 1 : 0.6;
		
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

		if(grid != null) {
			TitleState.gridXPosition = grid.x;
			TitleState.gridYPosition = grid.y;
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
					if(controls.UI_LEFT_P && dlcOption != null) {
						curColumn = DLC;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					} else if(controls.UI_RIGHT_P && shopOption != null) {
						curColumn = SHOP;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					}

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
				case DLC:
					if (curColumn == DLC) {
						if (controls.UI_LEFT_P) {
							curColumn = MAIN;
							changeItem();
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
							holdTime = 0;
						} else {
							if (controls.UI_RIGHT_P || controls.UI_DOWN_P) {
								curColumn = SHOP;
								changeItem();
								FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
								holdTime = 0;
							}
						}
					} 

					if (menuItems.members[curSelected].alpha == 1) {
						menuItems.members[curSelected].alpha = 0.6;

						if (lockItems.members[curSelected == 0 ? 0 : curSelected - 1] != null && lockItems.members[curSelected == 0 ? 0 : curSelected - 1].visible) {
							lockItems.members[curSelected == 0 ? 0 : curSelected - 1].alpha = 0.6;
						}
					}
				case SHOP:
					if (curColumn == SHOP) {
						if (controls.UI_LEFT_P) {
							curColumn = MAIN;
							changeItem();
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
							holdTime = 0;
						} else {
							if (controls.UI_RIGHT_P || controls.UI_UP_P) {
								curColumn = DLC;
								changeItem();
								FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
								holdTime = 0;
							}
						}
					}

					if (menuItems.members[curSelected].alpha == 1) {
						menuItems.members[curSelected].alpha = 0.6;

						if (lockItems.members[curSelected == 0 ? 0 : curSelected - 1] != null && lockItems.members[curSelected == 0 ? 0 : curSelected - 1].visible) {
							lockItems.members[curSelected == 0 ? 0 : curSelected - 1].alpha = 0.6;
						}
					}


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

					if (controls.UI_LEFT_P) {
						curColumn = DLC;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					}

					if (controls.UI_RIGHT_P) {
						curColumn = SHOP;
						changeItem();
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
						holdTime = 0;
					}

					if (menuItems.members[curSelected].alpha == 1) {
						menuItems.members[curSelected].alpha = 0.6;

						if (lockItems.members[curSelected == 0 ? 0 : curSelected - 1] != null && lockItems.members[curSelected == 0 ? 0 : curSelected - 1].visible) {
							lockItems.members[curSelected == 0 ? 0 : curSelected - 1].alpha = 0.6;
						}
					}
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
					FlxTween.cancelTweensOf(dlcItem);
					FlxTween.cancelTweensOf(shopItem);

					FlxTween.tween(div, {x: -1480}, 1.3, {ease: FlxEase.cubeOut, startDelay: 0.2});
					FlxTween.tween(mainBG, {alpha: 0, "scale.x": 1.2, "scale.y": 1.2}, 1.3, {ease: FlxEase.cubeOut});

					FlxTween.tween(dlcItem, {alpha: 0, y: -320}, 1.6, {ease: FlxEase.cubeOut});
					FlxTween.tween(lockSpriteDLC, {alpha: 0, y: -320}, 1.6, {ease: FlxEase.cubeOut});
					
					FlxTween.tween(bottomBG, {alpha: 0, y: 744}, 1.6, {ease: FlxEase.cubeOut});
					FlxTween.tween(bottomText, {alpha: 0, y: 748}, 1.6, {ease: FlxEase.cubeOut});

					FlxTween.tween(shopItem, {alpha: 0, x: 1300}, 1.6, {ease: FlxEase.cubeOut});
					FlxTween.tween(lockSpriteShop, {alpha: 0, x: 1300}, 1.6, {ease: FlxEase.cubeOut});
	
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

					for (i in 0...lockItems.length) {
						var lockItem = lockItems.members[i];
						var oX = lockItem.x - 850;
	
						lockItem.alpha = 0.6;
						FlxTween.cancelTweensOf(lockItem);
	
						if (i == 0)  {
							FlxTween.tween(lockItem, {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
							FlxTween.tween(lockItems.members[lockItems.length - 1], {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
						} else  {
							FlxTween.tween(lockItem, {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
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
					case DLC:
						option = 'dlcs';

					case SHOP:
						option = 'shop';

					case NONE:
						option = null;
				}

				if (option != null) {
					if (optionsBlocked.contains(optionShit[curSelected])) {
						FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
						selectedSomethin = false;
						canSelectSomething = true;
					} else {
						FlxG.sound.play(Paths.sound('confirmMenu'));
						selectedSomethin = true;
						if (option != 'storymode') 
							menuMoveTo(option);
						else
							introStoryMode();
					}
				}
			}

			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end

			#if debug 
			if (FlxG.keys.justPressed.ONE) {
				selectedSomethin = true;
				transition(new states.test.CursorTest());
			}
			#end
		}

		super.update(elapsed);
	}

	function introStoryMode() {
		FlxTween.cancelTweensOf(mainBG);
		FlxTween.cancelTweensOf(dlcItem);
		FlxTween.cancelTweensOf(shopItem);

		FlxTween.tween(div, {x: -1480}, 1.3, {ease: FlxEase.cubeOut, startDelay: 0.2});
		FlxTween.tween(mainBG, {x: -230, y: -30}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});
		FlxTween.tween(FlxG.camera, {zoom: 1.58}, 1.2, {ease: FlxEase.cubeOut, startDelay: 0.2});

		FlxTween.tween(dlcItem, {alpha: 0, y: -320}, 1.4, {ease: FlxEase.cubeOut});
		FlxTween.tween(lockSpriteDLC, {alpha: 0, y: -320}, 1.4, {ease: FlxEase.cubeOut});

		FlxTween.tween(shopItem, {alpha: 0, x: 1300}, 1.4, {ease: FlxEase.cubeOut});
		FlxTween.tween(lockSpriteShop, {alpha: 0, x: 1300}, 1.4, {ease: FlxEase.cubeOut});

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

		for (i in 0...lockItems.length) {
			var lockItem = lockItems.members[i];
			var oX = lockItem.x - 850;

			lockItem.alpha = 0.6;
			FlxTween.cancelTweensOf(lockItem);

			if (i == 0)  {
				FlxTween.tween(lockItem, {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
				FlxTween.tween(lockItems.members[lockItems.length - 1], {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
			} else  {
				FlxTween.tween(lockItem, {alpha: 0, x: oX}, 1.4, {ease: FlxEase.cubeOut});
			}
		}

		new FlxTimer().start(1.6, function(tmr:FlxTimer) {
			// FlxTransitionableState.skipNextTransIn = true;
			// FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new StoryMenuState());
		});
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
			case DLC:
				selectedItem = dlcItem;
			case SHOP:
				selectedItem = shopItem;
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

				if (lockItems.members[curSelected == 0 ? 0 : curSelected - 1] != null && lockItems.members[curSelected == 0 ? 0 : curSelected - 1].visible) {
					lockItems.members[curSelected == 0 ? 0 : curSelected - 1].alpha = (curColumn == MAIN) ? 1 : 0.6;
				}
			}
			
			if (dlcItem != null){
				dlcItem.alpha = (curColumn == DLC) ? 1 : 0.6;
				if (curColumn != DLC) {
					dlcItem.animation.play('idle');
					dlcItem.centerOffsets();
				}

				lockSpriteDLC.alpha = dlcItem.alpha;
			}

			if (shopItem != null) {
				shopItem.alpha = (curColumn == SHOP) ? 1 : 0.6;
				if (curColumn != SHOP) {
					shopItem.animation.play('idle');
					shopItem.centerOffsets();
				}
				lockSpriteShop.alpha = shopItem.alpha;
			}
			
			if (canSelectSomething) {
				selectedItem.animation.play('selected');
				selectedItem.centerOffsets();
			}
		}
	}

	// Mouse hover functions //

	//On hover
	function onOver(target:FlxSprite) {
		if (!selectedSomethin && canSelectSomething) {
			if (target == menuItems.members[curSelected]) {
				if (menuItems.members[curSelected] != null && curColumn == MAIN) {
					menuItems.members[curSelected].alpha = 1;
					if (lockItems.members[curSelected == 0 ? 0 : curSelected - 1] != null && lockItems.members[curSelected == 0 ? 0 : curSelected - 1].visible) {
						lockItems.members[curSelected == 0 ? 0 : curSelected - 1].alpha = 1;
					}
				} else {
					menuItems.members[curSelected].alpha = 0.6;
					if (lockItems.members[curSelected == 0 ? 0 : curSelected - 1] != null && lockItems.members[curSelected == 0 ? 0 : curSelected - 1].visible) {
						lockItems.members[curSelected == 0 ? 0 : curSelected - 1].alpha = 0.6;
					}
				}

				selectedItem = menuItems.members[curSelected];
	
				curColumn = MAIN;
				changeItem();
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			}
	
			if (target == dlcItem) {
				if (dlcItem != null && curColumn == DLC) {
					dlcItem.alpha = 1;
				} else {
					dlcItem.alpha = 0.6;
				}

				lockSpriteDLC.alpha = dlcItem.alpha;
				selectedItem = dlcItem;
				curColumn = DLC;
				changeItem();
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			}
	
			if (target == shopItem) {
				if (curColumn != SHOP) {
					if (shopItem != null && curColumn == SHOP) {
						shopItem.alpha = 1;
					} else {
						shopItem.alpha = 0.6;
					}

					lockSpriteShop.alpha = shopItem.alpha;
					selectedItem = shopItem;
					curColumn = SHOP;
					changeItem();
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
				}
			}
		}
	}

	// Not hover
	function onOut(target:FlxSprite) {
		if (!selectedSomethin && canSelectSomething) {
			if (target == menuItems.members[curSelected]) {
				if (menuItems.members[curSelected] != null && curColumn == MAIN) {
					menuItems.members[curSelected].alpha = 0.6;
					menuItems.members[curSelected].animation.play('idle');
					menuItems.members[curSelected].centerOffsets();
					
					if (lockItems.members[curSelected == 0 ? 0 : curSelected - 1] != null && lockItems.members[curSelected == 0 ? 0 : curSelected - 1].visible) {
						lockItems.members[curSelected == 0 ? 0 : curSelected - 1].alpha = 0.6;
					}
				} 

				selectedSomethin = false;
				canSelectSomething = true;
				curColumn = NONE;
			}
	
			if (target == dlcItem && curColumn == DLC) {
				if (dlcItem != null) {
					dlcItem.alpha = 0.6;
					dlcItem.animation.play('idle');
					dlcItem.centerOffsets();

					lockSpriteDLC.alpha = 0.6;
				}

				selectedSomethin = false;
				canSelectSomething = true;
				curColumn = NONE;
			}
	
			if (target == shopItem && curColumn == SHOP) {
				if (shopItem != null) {
					shopItem.alpha = 0.6;
					shopItem.animation.play('idle');
					shopItem.centerOffsets();

					lockSpriteShop.alpha = 0.6;
				}

				selectedSomethin = false;
				canSelectSomething = true;
				curColumn = NONE;
			}
		}
	}

	// On click
	function onClick(target:FlxSprite) {
		if (!selectedSomethin && canSelectSomething) {
			if (target == menuItems.members[curSelected]) {
				if (optionsBlocked.contains(optionShit[curSelected])) {
					FlxG.sound.play(Paths.sound('freeplay/locked'), 0.5);
					selectedSomethin = false;
					canSelectSomething = true;
				} else {
					FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;
					canSelectSomething = false;

					if (optionShit[curSelected] != 'storymode') 
						menuMoveTo(optionShit[curSelected]);
					else
						introStoryMode();
				}
			}

			if (target == dlcItem) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				canSelectSomething = false;
				transition(new DlcMenuState());
			}
			
			if (target == shopItem) {
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				canSelectSomething = false;
				transition(new ShopState());
			}
		}
	}
	////////

	function positionMenuItems(intro:Bool) {
		for (i in 0...menuItems.length) {
			var menuItem = menuItems.members[i];
			var lockItem = null;
			var offset:Float = FlxG.height / 2 - 350;
			var indexOffset = (i - curSelected + menuItems.length) % menuItems.length;

			if (i >= 0 && i <= 4 && i != 1) {
				lockItem = lockItems.members[i == 0 ? 0 : i - 1];
			}
			
			menuItem.y = (indexOffset * 180) + offset;
			if (lockItem != null && lockItem.visible) lockItem.y = menuItem.y + (menuItem.height / 2 - lockItem.height / 2);

			menuItem.alpha = (i == curSelected && canSelectSomething) ? 1 : 0.6;
			if (lockItem != null && lockItem.visible) lockItem.alpha = (i == curSelected && canSelectSomething) ? 1 : 0.6;

			if (lockItem != null && lockItem.visible) lockItem.scale.set(0.5, 0.5);
	
			// Ensure the previous item is also visible
			if (indexOffset == menuItems.length - 1) {
				menuItem.y = (-1 * 180) + offset;
				menuItem.alpha = 0.6;

				if (lockItem != null && lockItem.visible) {
					lockItem.y = menuItem.y + (menuItem.height / 2 - lockItem.height / 2);
					lockItem.alpha = 0.6;
				}
			}

			if (intro) {
				var oX = menuItem.x;
				var oXL = (lockItem != null && lockItem.visible) ? lockItem.x : 0;
				
				menuItem.x += -800;
				if (lockItem != null && lockItem.visible) lockItem.x += -800;
				
				FlxTween.cancelTweensOf(menuItems);
				if (lockItem != null && lockItem.visible) FlxTween.cancelTweensOf(lockItem);
	
				if (i == 0)  {
					FlxTween.tween(menuItems.members[menuItems.length - 1], {x: oX}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.2 + (0.1 * i)});
					if (lockItem != null && lockItem.visible) FlxTween.tween(lockItems.members[lockItems.length - 1], {x: oXL}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.2 + (0.1 * i)});

					FlxTween.tween(menuItem, {x: oX}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.3 + (0.1 * i)});
					if (lockItem != null && lockItem.visible) FlxTween.tween(lockItem, {x: oXL}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.3 + (0.1 * i)});
				}
				else {
					FlxTween.tween(menuItem, {x: oX}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.3 + (0.1 * i)});
					if (lockItem != null && lockItem.visible) FlxTween.tween(lockItem, {x: oXL}, 1.4, {ease: FlxEase.expoOut, startDelay: 0.3 + (0.1 * i)});
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

			#if ACHIEVEMENTS_ALLOWED
			case 'achievements':
				transition(new AchievementsMenuState());
			#end

			case 'gallery':
			transition(new GalleryState());

			case 'credits':
				transition(new CreditsState());
			case 'options':
				OptionsState.onPlayState = false;
				if (PlayState.SONG != null) {
					PlayState.SONG.arrowSkin = null;
					PlayState.SONG.splashSkin = null;
					PlayState.stageUI = 'normal';
				}

				transition(new OptionsState());
			case 'dlcs':
				transition(new DlcMenuState());

			case 'shop':
				transition(new ShopState());
		}
	}
}