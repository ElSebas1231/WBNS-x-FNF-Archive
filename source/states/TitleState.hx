package states;

import backend.WeekData;
import backend.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import haxe.Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;

import states.StoryMenuState;
import states.OutdatedState;
import states.MainMenuState;

typedef TitleData =
{
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Float
}

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var gridXPosition:Float = 0;
	public static var gridYPosition:Float = 0;

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	
	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, 0];

	var curWacky:Array<String> = [];
	var curWacky2:Array<String> = [];

	var wackyImage:FlxSprite;
	var mustUpdate:Bool = false;
	var titleJSON:TitleData;

	public static var updateVersion:String = '';

	public static var mainMenuBack:Bool = false;

	override public function create():Void
	{
		Paths.clearStoredMemory();

		#if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		curWacky = FlxG.random.getObject(getIntroTextShit());
		curWacky2 = FlxG.random.getObject(getIntroTextShit());

		// Makin sure both are diferents
		while (curWacky2 == curWacky) {
			curWacky2 = FlxG.random.getObject(getIntroTextShit());
		}

		super.create();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		if(!initialized) {
			ClientPrefs.loadPrefs();
			Language.reloadPhrases();
		}

		trace('Current money: ${CoinsManager.getCoins()}');

		Highscore.load();

		// IGNORE THIS!!!
		titleJSON = tjson.TJSON.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		Cursor.hide();
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else if(!CoffeTeamState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new CoffeTeamState());
		} else {
			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var background1:FlxSprite;
	var background2:FlxSprite;
	var grid:FlxBackdrop;

	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}

		Conductor.bpm = titleJSON.bpm;
		persistentUpdate = true;

		var theBackOne:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF121227);
		add(theBackOne);

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.loadGraphic(Paths.image('ui/menus/utils/stars'));
		add(bg);
		
		grid = new FlxBackdrop(Paths.image('ui/menus/titlemenu/checker'));
		grid.scale.set(0.3, 0.3);
		grid.velocity.set(40, -40);
		grid.alpha = 0.45;
		add(grid);

		grid.x = gridXPosition;
		grid.y = gridYPosition;

		background1 = new FlxSprite().loadGraphic(Paths.image('ui/menus/titlemenu/bg1'));
		background1.antialiasing = ClientPrefs.data.antialiasing;
		background1.scale.set(1.15, 1.15);
		background1.alpha = 0;
		add(background1);
		
		background2 = new FlxSprite().loadGraphic(Paths.image('ui/menus/titlemenu/bg2'));
		background2.antialiasing = ClientPrefs.data.antialiasing;
		background2.scale.set(1.15, 1.15);
		background2.alpha = 0;
		add(background2);

		logoBl = new FlxSprite().loadGraphic(Paths.image('ui/menus/titlemenu/logo_v2'));
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.scale.set(0.69, 0.68);
		logoBl.updateHitbox();
		logoBl.screenCenter(X);
		logoBl.y = 20;

		if (ClientPrefs.data.shaders) swagShader = new ColorSwap();

		if(swagShader != null) {
			background1.shader = background2.shader = bg.shader = logoBl.shader = swagShader.shader;
		}

		titleText = new FlxSprite(0, 0); //576
		titleText.frames = Paths.getSparrowAtlas('ui/menus/titlemenu/title_enter');
		titleText.animation.addByPrefix('idle', "title enter idle", 24);
		titleText.animation.addByPrefix('press', "title enter press", 24);
		titleText.animation.play('idle');
		titleText.updateHitbox();
		//titleText.screenCenter(X);
		add(titleText);

		logoBl.y = 720;

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;
		add(logoBl);

		if (initialized)
			skipIntro();
		else
			initialized = true;

		Paths.clearUnusedMemory();
		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		#if MODS_ALLOWED
		var firstArray:Array<String> = Mods.mergeAllTextsNamed('data/introText.txt', Paths.getSharedPath());
		#else
		var fullText:String = Assets.getText(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		#end
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray) {
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;
	
	var newTitle:Bool = true;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if(grid != null)
		{
			gridXPosition = grid.x;
			gridYPosition = grid.y;
		}

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
				//titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}
			
			if(pressedEnter)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');
				//FlxTween.shake(titleText, 0.003, 0.4, FlxAxes.XY, {ease: FlxEase.cubeOut});

				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				FlxTween.tween(background1, {alpha: 0, "scale.x": 1.15, "scale.y": 1.15}, 1.3, {ease: FlxEase.cubeIn, startDelay: 0.7});
				FlxTween.tween(background2, {alpha: 0, "scale.x": 1.15, "scale.y": 1.15}, 1.3, {ease: FlxEase.cubeIn, startDelay: 0.7});

				FlxTween.tween(logoBl, {alpha: 0, "scale.x": 1.3, "scale.y": 1.3}, 1, {ease: FlxEase.quartIn, startDelay: 1.2});
				FlxTween.tween(titleText, {alpha: 0}, 0.8, {ease: FlxEase.quartIn, startDelay: 1.2});

				new FlxTimer().start(2.7, function(tmr:FlxTimer)
				{
					if (mustUpdate) {
						MusicBeatState.switchState(new OutdatedState());
					} else {
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						MusicBeatState.switchState(new MainMenuState());
					}
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null) {
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	private var isLogoTweenActive:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(!closedState) {
			sickBeats++;
			//trace('Beat: $sickBeats | time: ${FlxG.sound.music.time}');
			switch (sickBeats)
			{
				case 1:
					//FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 1);
				case 2:
					createCoolText(['CoffeAndTeam presenta']);
				case 6:
					addMoreText('El trabajo de');
				case 8:
					addMoreText('muchísimas personas', 40);
				case 11:
					deleteCoolText();
				case 12:
					createCoolText(['Un mod basado'], -40);
				case 16:
					addMoreText('En los WBNS', -40);
				case 18:
					deleteCoolText();
				case 24:
					if (curWacky[0] != null) addMoreText(curWacky[0]);
				case 28:
					if (curWacky[1] != null) addMoreText(curWacky[1], 40);
				case 32:
					if (curWacky[2] != null) addMoreText(curWacky[2], 80);
				case 35:
					deleteCoolText();
				case 37:
					if (curWacky2[0] != null) addMoreText(curWacky2[0]);
				case 41:
					if (curWacky2[1] != null) addMoreText(curWacky2[1], 40);
				case 45:
					if (curWacky2[2] != null) addMoreText(curWacky2[2], 80);
				case 47:
					deleteCoolText();
				case 52:
					createCoolText(['Bienvenidos a']);
				case 56:
					addMoreText('WBNS');
				case 58:
					deleteCoolText();
					createCoolText(['Bienvenidos a']);
					addMoreText('WBNS');
					addMoreText('por');
				case 60:
					deleteCoolText();
					createCoolText(['Bienvenidos a']);
					addMoreText('WBNS');
					addMoreText('X');
				case 62:
					isLogoTweenActive = true;
					FlxTween.tween(logoBl, {y: 20}, (Conductor.crochet / 1000) * 2.5, {ease: FlxEase.quartOut});
				case 64:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			if (!mainMenuBack) {
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 1);
	
				if(!isLogoTweenActive) logoBl.y = 20;
				else {} // do nothing
				
				FlxTween.tween(background1, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.3, {ease: FlxEase.cubeOut, startDelay: 0.7});
				FlxTween.tween(background2, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.3, {ease: FlxEase.cubeOut, startDelay: 0.7});
				skippedIntro = true;
			} else {
				remove(credGroup);

				logoBl.y = 20;
				logoBl.alpha = 0;
				background1.alpha = 0;
				background2.alpha = 0;
				
				background1.scale.set(1.15, 1.15);
				background2.scale.set(1.15, 1.15);
				logoBl.scale.set(1.3, 1.3);

				var titleTextOY = titleText.y;
				titleText.y = 820;
				
				FlxTween.tween(titleText, {alpha: 1}, 1.3, {ease: FlxEase.cubeIn, startDelay: 0.2});
				FlxTween.tween(titleText, {y: titleTextOY}, 1.4, {ease: FlxEase.cubeIn, startDelay: 0.3});
				FlxTween.tween(logoBl, {alpha: 1, "scale.x": 0.65, "scale.y": 0.65}, 1, {ease: FlxEase.quartIn, startDelay: 0.2});
				FlxTween.tween(background1, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.1, {ease: FlxEase.cubeIn, startDelay: 0.5});
				FlxTween.tween(background2, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.1, {ease: FlxEase.cubeIn, startDelay: 0.5});

				skippedIntro = true;
				mainMenuBack = false;
			}
		}
	}
}