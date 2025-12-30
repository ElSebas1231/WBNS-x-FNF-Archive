package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import substates.StickerSubState;
import flixel.graphics.FlxGraphic;
import flixel.addons.display.FlxBackdrop;
import states.freeplay.FreeplaySections;

import objects.StoryMenuItem;

class StoryMenuState extends MusicBeatState {
	var bg:FlxSprite;
	var arrowLeft:FlxSprite;
	var arrowRight:FlxSprite;
	var title:FlxSprite;
	var weekNameSpr:FlxSprite;
	var diffShadow:FlxBackdrop;
	var difficultyBack:FlxSprite;
	var sprDifficulty:FlxSprite;
	var stars:FlxBackdrop;
	var grid:FlxBackdrop;

	var missingTextBG:FlxSprite;
	var missingTextBox:FlxSprite;
	var missingText:FlxText;
	var missingTextTimer:FlxTimer;
	
	var weekTxt:FlxText;
	var weekScore:FlxText;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;
	var curDifficulty:Int = -1;
	var intendedColor:Int;
	private static var lastDifficultyName:String = Difficulty.getDefault();
	private static var diffColors:Array<{difficulty:String, color:String}> = [
		{difficulty: 'soarinng', color: 'e6e600'},
		{difficulty: 'normal', color: 'e69200'},
		{difficulty: 'hard', color: 'e63200'},
		{difficulty: 'insane', color: '8a00e6'},
	];

	private static var curWeek:Int = 0;
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var grpWeekIslands:FlxTypedGroup<StoryMenuItem>;
	var grpIslandsCircles:FlxTypedGroup<FlxSprite>;
	var loadedWeeks:Array<WeekData> = [];
	
	var stickerSubState:StickerSubState;
	public function new(?stickers:StickerSubState = null) {
		super();
	  
		if (stickers != null) stickerSubState = stickers;
	}
	

	override function create() {
		Paths.clearUnusedMemory();
		if (stickerSubState != null && !ClientPrefs.data.noStickers) {
			openSubState(stickerSubState);
			stickerSubState.degenStickers();
		} else {
			Paths.clearStoredMemory();
		}

		FreeplaySections.sectionSelected = 'storymode';

		WeekData.weeksList = [];
		WeekData.weeksLoaded.clear();
		PlayState.isStoryMode = true;
		WeekData.addByDirectory(Paths.getSharedPath('weeks/storymode'));
		
		if (curWeek >= WeekData.weeksList.length) curWeek = 0;

		Difficulty.resetList();
		if(lastDifficultyName == '') lastDifficultyName = Difficulty.getDefault();
		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
		
		var bgColor:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF121227);
		add(bgColor);

		grid = new FlxBackdrop(Paths.image('ui/menus/titlemenu/checker'));
		grid.x = TitleState.gridXPosition;
		grid.y = TitleState.gridYPosition;
		grid.scale.set(0.3, 0.3);
		grid.velocity.set(40, -40);
		grid.alpha = 0.45;
		add(grid);

		var stars:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/menus/utils/stars'));
		stars.antialiasing = ClientPrefs.data.antialiasing;
		add(stars);

		diffShadow = new FlxBackdrop(Paths.image('ui/menus/storymenu/diff shadow'), X);
		diffShadow.flipY = true;
		diffShadow.y = 10;
		diffShadow.velocity.x = 10;
		diffShadow.color = FlxColor.fromString('#${diffColors[curDifficulty].color}');
		add(diffShadow);

		intendedColor = diffShadow.color;

		bg = new FlxSprite().loadGraphic(Paths.image('ui/menus/storymenu/bg'));
		bg.screenCenter();
		add(bg);

		grpIslandsCircles = new FlxTypedGroup<FlxSprite>();
		add(grpIslandsCircles);

		grpWeekIslands = new FlxTypedGroup<StoryMenuItem>();
		add(grpWeekIslands);
		
		var num:Int = 0;
		for (i in 0...WeekData.weeksList.length) {
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			
			if (!isLocked || !weekFile.hiddenUntilUnlocked) {
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);

				var island:StoryMenuItem = new StoryMenuItem(WeekData.weeksList[i], isLocked);
				island.targetY = num;
				grpWeekIslands.add(island);

				num++;
			}
		}

		for (i in 1...grpWeekIslands.length) {
			var circles:FlxSprite = new FlxSprite(0, 414).loadGraphic(Paths.image('ui/menus/storymenu/circles'));
			circles.scale.set(0.85, 0.85);
			grpIslandsCircles.add(circles);
		}

		arrowLeft = new FlxSprite(305, 167).loadGraphic(Paths.image('ui/menus/storymenu/arrow'));
		arrowLeft.flipX = true;
		add(arrowLeft);

		weekNameSpr = new FlxSprite(0, 137).loadGraphic(Paths.image('ui/menus/storymenu/titles/tutorial'));
		weekNameSpr.scale.set(0.6, 0.6);
		weekNameSpr.updateHitbox();
		weekNameSpr.screenCenter(X);
		add(weekNameSpr);

		arrowRight = new FlxSprite(945, 167).loadGraphic(Paths.image('ui/menus/storymenu/arrow'));
		add(arrowRight);

		difficultyBack = new FlxSprite(750, 520).loadGraphic(Paths.image('ui/menus/storymenu/difficults/dificult_back'));
		difficultyBack.antialiasing = ClientPrefs.data.antialiasing;
		add(difficultyBack);

		sprDifficulty = new FlxSprite(difficultyBack.x + 100, difficultyBack.y + 45);
		sprDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		add(sprDifficulty);

		title = new FlxSprite().loadGraphic(Paths.image('ui/menus/storymenu/title'));
		title.screenCenter();
		add(title);

		weekTxt = new FlxText(5, 590, 1800, 'Week Score:');
		weekTxt.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), 30, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		weekTxt.antialiasing = ClientPrefs.data.antialiasing;
		add(weekTxt);

		weekScore = new FlxText(0, 620, 1800, '');
		weekScore.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), 80, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		weekScore.antialiasing = ClientPrefs.data.antialiasing;
		add(weekScore);

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingTextBox = new FlxSprite().makeGraphic(1200, 500, FlxColor.WHITE);
		missingTextBox.screenCenter();
		missingTextBox.alpha = 0.8;
		missingTextBox.visible = false;
		add(missingTextBox);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		missingText.antialiasing = ClientPrefs.data.antialiasing;
		add(missingText);

		for (child in members) {
			if (Std.is(child, FlxSprite)) {
				var sprite:FlxSprite = cast child;
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
		
		changeWeek();
		doIntro();

		super.create();
	}

	var exitting:Bool = false;
	var holdTime:Float = 0;
	var canSelect:Bool = true;

	var arrowLeftTween:FlxTween;
    var arrowRightTween:FlxTween;
	var arrowTween:FlxTween;

	override function update(elapsed:Float) {
		lerpScore = MathUtil.smoothLerp(lerpScore, intendedScore, elapsed * 5, 0.5);
		
		if (Math.abs(lerpScore - intendedScore) <= 10) lerpScore = intendedScore;

		weekScore.text = '${Std.int(lerpScore)}';

		if (!exitting && canSelect) {
			var shiftMult:Int = 1;
			if (FlxG.keys.pressed.SHIFT) shiftMult = 3;

			if (controls.UI_LEFT_P) {
				changeWeek(-shiftMult);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
				holdTime = 0;

				if(arrowLeftTween != null) arrowLeftTween.cancel();

				arrowLeft.scale.set(1.25, 1.25);
				arrowLeftTween = FlxTween.tween(arrowLeft.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						arrowLeftTween = null;
					}
				});
			}

			if (controls.UI_RIGHT_P) {
				changeWeek(shiftMult);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
				holdTime = 0;
			}

			if (controls.UI_RIGHT || controls.UI_LEFT) {
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0) {
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
					changeWeek((checkNewHold - checkLastHold) * (controls.UI_LEFT ? -shiftMult : shiftMult));
				}

				var arrow:FlxSprite = controls.UI_LEFT ? arrowLeft : arrowRight;

				if (arrowTween != null) arrowTween.cancel();

				arrow.scale.set(1.25, 1.25);
				arrowTween = FlxTween.tween(arrow.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						arrowTween = null;
					}
				});
			}

			if (controls.UI_UP_P) {
				changeDiff(1); 
			} else if (controls.UI_DOWN_P) {
				changeDiff(-1); 
			}

			if (controls.ACCEPT) {
				selectWeek();
				canSelect = false;
			}

			if (controls.BACK) doOutro();
		}

		for (i in 0...grpIslandsCircles.length) {
			grpIslandsCircles.members[i].setPosition(grpWeekIslands.members[i+1].x - 180, grpIslandsCircles.members[i].y);
		}

		#if debug
		if (FlxG.keys.justPressed.ONE) {
			Highscore.saveWeekScore('week1', 1234567890, 0);
			trace('1');
		}
		
		if (FlxG.keys.justPressed.TWO) {
			Highscore.resetWeek('week1', 0);
			trace('2');
		}
		#end

		super.update(elapsed);
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function doIntro() {
		canSelect = false;

		for (obj in [arrowLeft, diffShadow, weekNameSpr, arrowRight, weekTxt, weekScore, difficultyBack, sprDifficulty]){
			FlxTween.cancelTweensOf(obj);
			obj.alpha = 0;
            FlxTween.tween(obj, {alpha: 1}, 1.5, {ease: FlxEase.cubeOut, startDelay: 1.2});
        }

		for (i in 0...grpWeekIslands.length) {
			var island = grpWeekIslands.members[i];

			island.x = island.targetY * 700 + 250;
			island.y += 50;
			island.alpha = 0;
			FlxTween.tween(island, {y: island.y - 50, alpha: 1}, 1.2, {ease: FlxEase.smoothStepIn});
		}

		for (i in 0...grpIslandsCircles.length){
			var circles = grpIslandsCircles.members[i];

			circles.alpha = 0;
			FlxTween.tween(circles, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepIn, startDelay: 1.2});
		}

		new FlxTimer().start(2.2, function(tmr:FlxTimer) {
			canSelect = true;
		});
	}

	function doOutro() {
		exitting = true;
		canSelect = false;

		for (obj in [title, bg, diffShadow, arrowLeft, weekNameSpr, arrowRight, weekTxt, weekScore, difficultyBack, sprDifficulty]){
			FlxTween.cancelTweensOf(obj);
            FlxTween.tween(obj, {alpha: 0}, 0.8, {ease: FlxEase.cubeOut});
        }

		for (i in 0...grpIslandsCircles.length){
			var circles = grpIslandsCircles.members[i];
			FlxTween.tween(circles, {alpha: 0}, 0.4, {ease: FlxEase.smoothStepIn});
		}

		for (i in 0...grpWeekIslands.length) {
			var island = grpWeekIslands.members[i];
			FlxTween.tween(island, {y: island.y + 50, alpha: 0}, 0.8, {ease: FlxEase.smoothStepIn});
		}

		new FlxTimer().start(2.8, function(tmr:FlxTimer) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new MainMenuState());
		});
	}
	var tweenWeekSpr:FlxTween;
	function changeWeek(change:Int = 0):Void {
		curWeek += change;

		if (curWeek >= loadedWeeks.length) curWeek = 0;
		if (curWeek < 0) curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var bullShit:Int = 0;
		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (item in grpWeekIslands.members) {
			item.targetY = bullShit - curWeek;
			bullShit++;
		}

		var newImage:FlxGraphic = Paths.image('ui/menus/storymenu/titles/${loadedWeeks[curWeek].fileName}');
		if (weekNameSpr.graphic != newImage) {
			weekNameSpr.loadGraphic(newImage);
			weekNameSpr.scale.set(0.6, 0.6);
			weekNameSpr.updateHitbox();
			weekNameSpr.screenCenter(X);
			weekNameSpr.alpha = 0;
			weekNameSpr.y = weekNameSpr.y - 15;

			if (tweenWeekSpr != null) tweenWeekSpr.cancel();
			tweenWeekSpr = FlxTween.tween(weekNameSpr, {y: weekNameSpr.y + 15, alpha: 1}, 0.1, {onComplete: function(twn:FlxTween) {
				tweenWeekSpr = null;
			}});
		}

		PlayState.storyWeek = curWeek;
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);

		changeDiff();
	}

	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek() {
		if (!weekIsLocked(loadedWeeks[curWeek].fileName)) {
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
			for (i in 0...leWeek.length) {
				songArray.push(leWeek[i][0]);
			}

			try {
				PlayState.storyPlaylist = songArray;
				PlayState.isStoryMode = true;
				selectedWeek = true;
	
				var diffic = Difficulty.getFilePath(curDifficulty);
				if(diffic == null) diffic = '';
	
				PlayState.storyDifficulty = curDifficulty;
	
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, 'storymode/${PlayState.storyPlaylist[0].toLowerCase()}');
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
			} catch(e:Dynamic) {
				trace('ERROR! $e');

				var errorStr:String = e.toString();
				if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(22, errorStr.length-1); //Missing chart

				if (missingTextTimer != null){
					missingTextTimer.cancel();
				}

				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
				missingText.visible = true;
				missingTextBox.visible = true;
				missingTextBG.visible = true;

				missingTextTimer = new FlxTimer().start(3, function(tmr:FlxTimer) {
					missingText.visible = false;
					missingTextBG.visible = false;
					missingTextBox.visible = false;
				});
				return;
			}
			
			if (stopspamming == false) {
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekIslands.members[curWeek].isFlashing = true;
				stopspamming = true;
			}

			new FlxTimer().start(1, function(tmr:FlxTimer) {
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		} else FlxG.sound.play(Paths.sound('cancelMenu'));
	}

	var tweenDifficulty:FlxTween;
	function changeDiff(change:Int = 0) {
		curDifficulty += change;
		
		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		if (missingTextTimer != null) missingTextTimer.cancel();
		missingText.visible = false;
		missingTextBox.visible = false;
		missingTextBG.visible = false;

		lastDifficultyName = Difficulty.getString(curDifficulty);
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);

		var newColor:Int = FlxColor.fromString('#${diffColors[curDifficulty].color}');
		if(newColor != intendedColor) {
			intendedColor = newColor;
			FlxTween.cancelTweensOf(diffShadow);
			FlxTween.color(diffShadow, 1, diffShadow.color, intendedColor);
		}

		var newImage:FlxGraphic = Paths.image('ui/menus/storymenu/difficults/dificult_${lastDifficultyName.toLowerCase()}');
		if (sprDifficulty.graphic != newImage) {
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.alpha = 0;
			sprDifficulty.y = sprDifficulty.y - 15;

			if (tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: sprDifficulty.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween) {
				tweenDifficulty = null;
			}});
		}
	}
}