package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import states.freeplay.FreeplaySections;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxAxes;
import haxe.Json;
import Lambda;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import states.StoryMenuState;
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

	public static var initialized:Bool = false;

	var easterEggKey:Array<String> = ['SPOOKY', 'LEFORDE', 'P3L33'];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
	var easterEggKeyBuffer:String = '';

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
	private static var blocked:Bool = false;

	public static var mainMenuBack:Bool = false;
	public static var secretSongLoaded:Bool = false;

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

		if (FlxG.save.data.weekCompleted != null) StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;

		Cursor.hide();

		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else if(!IntroVideoState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new IntroVideoState());
		} else {
			if (initialized)
				startIntro();
			else {
				new FlxTimer().start(1, function(tmr:FlxTimer) {
					startIntro();
				});
			}
		}
	}

	var logoBl:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized) {
			if (FlxG.sound.music == null) FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		}

		Conductor.bpm = titleJSON.bpm;
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.loadGraphic(Paths.image('ui/menus/utils/stars'));
		add(bg);

		logoBl = new FlxSprite().loadGraphic(Paths.image('ui/menus/titlemenu/logo_v2'));
		logoBl.antialiasing = ClientPrefs.data.antialiasing;
		logoBl.scale.set(0.69, 0.68);
		logoBl.updateHitbox();
		logoBl.screenCenter(X);
		logoBl.y = 20;

		titleText = new FlxSprite(0, 0); //576
		titleText.frames = Paths.getSparrowAtlas('ui/menus/titlemenu/title_enter');
		titleText.animation.addByPrefix('idle', "title enter idle", 24);
		titleText.animation.addByPrefix('press', "title enter press", 24);
		titleText.animation.play('idle');
		titleText.antialiasing = ClientPrefs.data.antialiasing;
		titleText.updateHitbox();
		add(titleText);

		logoBl.y = 720;

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
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
		var fullText:String = Assets.getText(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
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

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;
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
			
			if (pressedEnter) {
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');
				//FlxTween.shake(titleText, 0.003, 0.4, FlxAxes.XY, {ease: FlxEase.cubeOut});

				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				FlxTween.tween(logoBl, {alpha: 0, "scale.x": 1.3, "scale.y": 1.3}, 1, {ease: FlxEase.quartIn, startDelay: 1.2});
				FlxTween.tween(titleText, {alpha: 0}, 0.8, {ease: FlxEase.quartIn, startDelay: 1.2});

				new FlxTimer().start(2.7, function(tmr:FlxTimer) {
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			} else if (FlxG.keys.firstJustPressed() != FlxKey.NONE) {
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);

				switch (keyName) {
					case "ZERO": keyName = "0";
					case "ONE": keyName = "1";
					case "TWO": keyName = "2";
					case "THREE": keyName = "3";
					case "FOUR": keyName = "4";
					case "FIVE": keyName = "5";
					case "SIX": keyName = "6";
					case "SEVEN": keyName = "7";
					case "EIGHT": keyName = "8";
					case "NINE": keyName = "9";
				}

				if (allowedKeys.contains(keyName)) {
					easterEggKeyBuffer += keyName;
					if (easterEggKeyBuffer.length >= 32) easterEggKeyBuffer = easterEggKeyBuffer.substring(1);

					for (wordRaw in easterEggKey) {
						var word:String = wordRaw.toUpperCase();
		
						if (easterEggKeyBuffer.contains(word)) {			
							trace(word);
							
							switch (word) {
								case "SPOOKY": 
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new JumpScareState());
								case "P3L33": 
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;

									FlxG.camera.fade(FlxColor.BLACK, 0.5);
									FlxG.sound.music.fadeOut(0.5, 0, function(twn:FlxTween) {
										MusicBeatState.switchState(new VideoPlayerState('pilin'));
									});
								case "LEFORDE":
									FlxG.sound.play(Paths.sound('jingle'));
									FreeplaySections.sectionSelected = 'duxomadness';
									PlayState.SONG = Song.loadFromJson('leforde-hard', 'duxomadness/leforde');
									PlayState.isStoryMode = false;
									PlayState.storyDifficulty = 0;

									trace(ClientPrefs.data.secretSongsUnlocked);

									if (Lambda.find(ClientPrefs.data.secretSongsUnlocked, s -> s.name == "Leforde") == null) {
										ClientPrefs.data.secretSongsUnlocked.push({name: "Leforde", healthIcon: "snack"});
										ClientPrefs.saveSettings();
										FlxG.save.flush();
									} 

									trace(ClientPrefs.data.secretSongsUnlocked);
									
									FlxG.camera.fade(FlxColor.BLACK, 0.5);
									FlxG.sound.music.fadeOut(0.5, 0, function (twn:FlxTween) {
										FlxTransitionableState.skipNextTransIn = true;
										FlxTransitionableState.skipNextTransOut = true;
										secretSongLoaded = true;

										LoadingState.prepareToSong();
										LoadingState.loadAndSwitchState(new PlayState());
									});

									closedState = true;
									transitioning = true;
							}	
						}
					}
				}
			}
		}

		if (initialized && pressedEnter && !skippedIntro) skipIntro();

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
					addMoreText('¿En los WBNS?', -40);
				case 18:
					deleteCoolText();
				case 24:
					createCoolText(['Al fin de cuentas']);
				case 28:
					addMoreText('Esto no revivió', 40);
				case 32:
					deleteCoolText();
				case 35:
					createCoolText(['Al parecer']);
				case 39:
					addMoreText('Nos divertiremos', 40);
				case 43:
					addMoreText('Por más tiempo', 80);
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
	function skipIntro():Void {
		if (!skippedIntro)
		{
			if (FlxG.sound.music == null || FlxG.sound.music.volume == 0) FlxG.sound.playMusic(Paths.music('freakyMenu'));
			if (!mainMenuBack) {
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 1);
	
				if(!isLogoTweenActive) logoBl.y = 20;
				
				skippedIntro = true;
			} else {
				remove(credGroup);

				logoBl.y = 20;
				logoBl.alpha = 0;
				logoBl.scale.set(1.3, 1.3);

				var titleTextOY = titleText.y;
				titleText.y = 820;
				
				FlxTween.tween(titleText, {alpha: 1}, 1.3, {ease: FlxEase.cubeIn, startDelay: 0.2});
				FlxTween.tween(titleText, {y: titleTextOY}, 1.4, {ease: FlxEase.cubeIn, startDelay: 0.3});
				FlxTween.tween(logoBl, {alpha: 1, "scale.x": 0.65, "scale.y": 0.65}, 1, {ease: FlxEase.quartIn, startDelay: 0.2});

				skippedIntro = true;
				mainMenuBack = false;
			}
		}

		openfl.Lib.application.window.title = "WBNS x Friday Night Funkin': Duxo Madness";
		openfl.Lib.application.window.setIcon(lime.graphics.Image.fromFile("assets/shared/images/ui/menus/utils/icon.png"));
		DiscordClient.changePresence("In the Title Screen");
	}
}