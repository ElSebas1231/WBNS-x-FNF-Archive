package states.results;

import backend.Highscore;
import flixel.addons.transition.FlxTransitionableState;
import substates.StickerSubState;
import states.freeplay.FreeplayState;
import backend.FunkinTools;
import backend.Scoring;
import backend.PsychCamera;
import backend.animation.FlxAtlasSprite;
import shaders.LeftMaskShader;
import flixel.FlxSprite;
import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;

import flixel.math.FlxRect;
import flixel.text.FlxBitmapText;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;

import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;

import shaders.ColorGradientShader;

import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
using backend.FunkinTools;

/**
 * The state for the results screen after a song or week is finished.
 */
//@:nullSafety
class ResultState extends MusicBeatSubstate
{
	final params:ResultsStateParams;

	final rank:ScoringRank;
	final songName:FlxBitmapText;
	final difficulty:FlxBitmapText;
	final clearPercentSmall:ClearPercentCounter;
	final clearPercentCounter:ClearPercentCounter;

	final maskShaderSongName:LeftMaskShader = new LeftMaskShader();
	final maskShaderDifficulty:LeftMaskShader = new LeftMaskShader();

	final resultsAnim:FlxSprite;
	final ratingsPopin:FlxSprite;
	final scorePopin:FlxSprite;

	final bgFlash:FlxSprite;

	final highscoreNew:FlxSprite;
	final score:ResultScore;

	var rankBg:FlxSprite;
	var resultsCharacter:FlxSprite;
	final cameraBG:PsychCamera;
	final cameraScroll:PsychCamera;
	final cameraEverything:PsychCamera;
	final cameraOverlay:PsychCamera;
	var resultingAccuracy:Float;

	var exiting:Bool = false;
	var shownRank:Bool = false;
	var charGoToX:Float = 0;

	public function new(params:ResultsStateParams)
	{
		super();

		this.params = params;

		resultingAccuracy = Math.min(1, (params.scoreData.sick + params.scoreData.good - params.scoreData.missed) / params.scoreData.totalNotesHit); 
		if (params.scoreData.totalNotesHit == 0) resultingAccuracy = 0;

		rank = Scoring.calculateRankFromData(params.scoreData.score, resultingAccuracy) ?? SHIT;

		cameraBG = new PsychCamera( 0, 0, FlxG.width, FlxG.height);
		cameraScroll = new PsychCamera(0, 0, FlxG.width, FlxG.height);
		cameraEverything = new PsychCamera(0, 0, FlxG.width, FlxG.height);
		cameraOverlay = new PsychCamera(0, 0, FlxG.width, FlxG.height);

		var fontLetters:String = "AaBbCcDdEeFfGgHhiIJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz:1234567890.-'[]()";
		songName = new FlxBitmapText(FlxBitmapFont.fromMonospace(Paths.image("ui/menus/resultScreen/resultFont"), fontLetters, FlxPoint.get(49, 62)));
		songName.text = params.title;
		songName.letterSpacing = -15; //!!!
		songName.antialiasing = ClientPrefs.data.antialiasing;
		songName.angle = -4.4;
		
		var difColor = PlayState.storyDifficultyColor;
		difficulty = new FlxBitmapText(FlxBitmapFont.fromMonospace(Paths.image("ui/menus/resultScreen/resultFont"), fontLetters, FlxPoint.get(49, 62)));
		difficulty.text = Difficulty.list[PlayState.storyDifficulty].toUpperCase();
		difficulty.letterSpacing = -12; //!!!
		difficulty.angle = -4.4;
		difficulty.antialiasing = ClientPrefs.data.antialiasing;

		// FPS Plus thingie
		var songNameShader = new ColorGradientShader(0xFFF98862, 0xFFF9FEB1);
		var difficultyShader = new ColorGradientShader(PlayState.storyDifficultyColor[0], PlayState.storyDifficultyColor[1]);
		songName.shader = songNameShader.shader;
		difficulty.shader = difficultyShader.shader;

		clearPercentSmall = new ClearPercentCounter(FlxG.width / 2 + 300, FlxG.height / 2 - 100, 100, true);
		clearPercentSmall.visible = false;

		clearPercentCounter = new ClearPercentCounter(FlxG.width / 2 + 190, FlxG.height / 2 - 70, 0);
		clearPercentCounter.visible = false;

		bgFlash = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xFFFFF1A6, 0xFFFFF1BE], 90);
		resultsAnim = FunkinTools.createSparrow(-200, -10, "ui/menus/resultScreen/results");
		ratingsPopin = FunkinTools.createSparrow(-135, 135, "ui/menus/resultScreen/ratingsPopin");
		scorePopin = FunkinTools.createSparrow(-180, 515, "ui/menus/resultScreen/scorePopin");
		highscoreNew = new FlxSprite(44, 557);
		score = new ResultScore(35, 305, 10, params.scoreData.score);
		rankBg = new FlxSprite(0, 0);
	}

	override function create():Void
	{
		if (FlxG.sound.music != null) FlxG.sound.music.stop();

		#if desktop
		DiscordClient.changePresence('Result Screen! - ' + (params.storyMode == false ? 'Freeplay' : 'Story Mode'), Difficulty.list[PlayState.storyDifficulty].toUpperCase() + ' - ' + params.title, 'results');
		#end

		cameraScroll.angle = -3.8;

		cameraBG.bgColor = FlxColor.fromString('#FDC05C');
		cameraScroll.bgColor = FlxColor.fromString('#FDC05C');
		cameraEverything.bgColor = FlxColor.TRANSPARENT;
		cameraOverlay.bgColor = FlxColor.TRANSPARENT;

		FlxG.cameras.add(cameraBG, false);
		FlxG.cameras.add(cameraScroll, false);
		FlxG.cameras.add(cameraEverything, false);
		FlxG.cameras.add(cameraOverlay, false);

		FlxG.cameras.setDefaultDrawTarget(cameraEverything, true);
		this.camera = cameraEverything;

		// Reset the camera zoom on the results screen.
		FlxG.camera.zoom = 1.0;

		var bg:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width*2, FlxG.height*2, [0xFFFECC5C, 0xFFFDC05C], 90);
		bg.scrollFactor.set();
		bg.cameras = [cameraBG];
		add(bg);

		bgFlash.scrollFactor.set();
		bgFlash.visible = false;
		add(bgFlash);

		resultsCharacter = new FlxSprite(0,0);
		resultsCharacter.frames = Paths.getMultiAtlas([
			'ui/menus/resultScreen/results/${FreeplayState.freeplayCharacter}_results-win',
			'ui/menus/resultScreen/results/${FreeplayState.freeplayCharacter}_results-lose'
		]);
		switch (FreeplayState.freeplayCharacter) {
			case 'aquino':
				resultsCharacter.animation.addByPrefix('win', 'result screen win animation', 12, false);
				resultsCharacter.animation.addByPrefix('lose', 'result screen lose animation', 12, true);
				resultsCharacter.animation.addByPrefix('idle', 'result screen win idle', 12, true);
				resultsCharacter.scale.set(0.5, 0.5);
				resultsCharacter.updateHitbox();
				resultsCharacter.animation.play('idle', true);
				resultsCharacter.x = 1100;
				resultsCharacter.y = 120;
				charGoToX = 580; // used in the tween in
			case 'c3jo':
				resultsCharacter.animation.addByPrefix('win', 'result screen win animation0', 12, false);
				resultsCharacter.animation.addByPrefix('idle', 'result screen win idle0', 12, true);
				resultsCharacter.animation.addByPrefix('lose', 'result screen lose animation0', 12, false);
				resultsCharacter.animation.addByPrefix('lose idle', 'result screen lose idle0', 12, true);
				resultsCharacter.scale.set(0.75, 0.75);
				resultsCharacter.updateHitbox();
				resultsCharacter.x = 1100;
				resultsCharacter.y = 30;
				charGoToX = 390; // used in the tween in
		}
		resultsCharacter.antialiasing = ClientPrefs.data.antialiasing;
		resultsCharacter.visible = false;

		// The sound system which falls into place behind the score text. Plays every time!
		var soundSystem:FlxSprite = FunkinTools.createSparrow(-15, -180, 'ui/menus/resultScreen/soundSystem');
		soundSystem.animation.addByPrefix("idle", "sound system", 24, false);
		soundSystem.visible = false;
		new FlxTimer().start(8 / 24, _ -> {
			soundSystem.animation.play("idle");
			soundSystem.visible = true;
		});

		add(difficulty);
		add(songName);

		var angleRad = songName.angle * Math.PI / 180;
		speedOfTween.x = -1.0 * Math.cos(angleRad);
		speedOfTween.y = -1.0 * Math.sin(angleRad);

		timerThenSongName(1.0, false);

		var blackTopBar:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ui/menus/resultScreen/topBarBlack"));
		blackTopBar.y = -blackTopBar.height;
		FlxTween.tween(blackTopBar, {y: 0}, 7 / 24, {ease: FlxEase.quartOut, startDelay: 3 / 24});
		if (resultsCharacter != null) add(resultsCharacter);
		add(blackTopBar);
		add(clearPercentSmall);
		add(clearPercentCounter);
		add(soundSystem);

		resultsAnim.animation.addByPrefix("result", "results instance 1", 24, false);
		resultsAnim.visible = false;
		add(resultsAnim);
		new FlxTimer().start(6 / 24, _ -> {
			resultsAnim.visible = true;
			resultsAnim.animation.play("result");
		});

		ratingsPopin.animation.addByPrefix("idle", "Categories", 24, false);
		ratingsPopin.visible = false;
		add(ratingsPopin);
		new FlxTimer().start(21 / 24, _ -> {
			ratingsPopin.visible = true;
			ratingsPopin.animation.play("idle");
		});

		scorePopin.animation.addByPrefix("score", "tally score", 24, false);
		scorePopin.visible = false;
		add(scorePopin);
		new FlxTimer().start(36 / 24, _ -> {
			scorePopin.visible = true;
			scorePopin.animation.play("score");
			scorePopin.animation.finishCallback = anim -> {};
		});

		new FlxTimer().start(37 / 24, _ -> {
			score.visible = true;
			score.animateNumbers();
			startRankTallySequence();
		});

		new FlxTimer().start(rank.getBFDelay(), _ -> {
			afterRankTallySequence();
		});

		new FlxTimer().start(rank.getFlashDelay(), _ -> {
			displayRankText();
		});

		highscoreNew.frames = Paths.getSparrowAtlas("ui/menus/resultScreen/highscoreNew");
		highscoreNew.animation.addByPrefix("new", "highscoreAnim0", 24, false);
		highscoreNew.visible = false;
		highscoreNew.updateHitbox();
		add(highscoreNew);

		new FlxTimer().start(rank.getHighscoreDelay(), _ -> {
			if (params.isNewHighscore ?? false) {
				highscoreNew.visible = true;
				highscoreNew.animation.play("new");
				highscoreNew.animation.finishCallback = _ -> highscoreNew.animation.play("new", true, false, 16);
			} else {
				highscoreNew.visible = false;
			}
		});

		var hStuf:Int = 50;

		var ratingGrp:FlxTypedGroup<TallyCounter> = new FlxTypedGroup<TallyCounter>();
		add(ratingGrp);

		var totalHit:TallyCounter = new TallyCounter(375, hStuf * 3, params.scoreData.totalNotesHit);
		ratingGrp.add(totalHit);

		var maxCombo:TallyCounter = new TallyCounter(375, hStuf * 4, params.scoreData.maxCombo);
		ratingGrp.add(maxCombo);

		hStuf += 2;
		var extraYOffset:Float = 7;

		hStuf += 2;

		var tallySick:TallyCounter = new TallyCounter(230, (hStuf * 5) + extraYOffset, params.scoreData.sick, 0xFF89E59E);
		ratingGrp.add(tallySick);

		var tallyGood:TallyCounter = new TallyCounter(210, (hStuf * 6) + extraYOffset, params.scoreData.good, 0xFF89C9E5);
		ratingGrp.add(tallyGood);

		var tallyBad:TallyCounter = new TallyCounter(190, (hStuf * 7) + extraYOffset, params.scoreData.bad, 0xFFE6CF8A);
		ratingGrp.add(tallyBad);

		var tallyShit:TallyCounter = new TallyCounter(220, (hStuf * 8) + extraYOffset, params.scoreData.shit, 0xFFE68C8A);
		ratingGrp.add(tallyShit);

		var tallyMissed:TallyCounter = new TallyCounter(260, (hStuf * 9) + extraYOffset, params.scoreData.missed, 0xFFC68AE6);
		ratingGrp.add(tallyMissed);

		score.visible = false;
		add(score);

		for (ind => rating in ratingGrp.members) {
			rating.visible = false;
			new FlxTimer().start((0.3 * ind) + 1.20, _ -> {
				rating.visible = true;
				FlxTween.tween(rating, {curNumber: rating.neededNumber}, 0.5, {ease: FlxEase.quartOut});
				playCounterSoundTickUp();
			});
		}

		new FlxTimer().start(rank.getMusicDelay(), _ -> {
			var rankMusicPath = rank.getMusicPath();
			if (rank.hasMusicIntro()) {
				FlxG.sound.play(Paths.music('results/' + rankMusicPath + '/' + rankMusicPath + '-intro'), 1, false, null, true,() -> {
					shownRank = true;
					FlxG.sound.playMusic(Paths.music('results/' + rankMusicPath + '/' + rankMusicPath), 1, true);
				});
			} else {
				shownRank = true;
				FlxG.sound.playMusic(Paths.music('results/' + rankMusicPath + '/' + rankMusicPath), 1, true);
			}
		});

		rankBg.makeSolidColor(FlxG.width, FlxG.height, 0xFF000000);
		rankBg.cameras = [cameraOverlay];
		rankBg.alpha = 0;

		// quick n dirty way to apply anit-aliasing to everything
		for (sprite in members) {
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}

		super.create();
	}

	var rankTallyTimer:Null<FlxTimer> = null;
	var clearPercentTarget:Int = 100;
	var clearPercentLerp:Int = 0;

	function startRankTallySequence():Void
	{
		bgFlash.visible = true;
		clearPercentCounter.visible = true;
		FlxTween.tween(bgFlash, {alpha: 0}, 5 / 24);
		var clearPercentFloat = resultingAccuracy* 100;
		clearPercentTarget = Math.floor(clearPercentFloat);
		// Prevent off-by-one errors.

		clearPercentLerp = Std.int(Math.max(0, clearPercentTarget - 36));

		//trace('Clear percent target: ' + clearPercentFloat + ', round: ' + clearPercentTarget);
		FlxTween.tween(clearPercentCounter, {curNumber: clearPercentTarget}, 58 / 24, {
			ease: FlxEase.quartOut,
			onUpdate: _ -> {
				// Only play the tick sound if the number increased.
				if (clearPercentLerp != clearPercentCounter.curNumber)
				{
					clearPercentLerp = clearPercentCounter.curNumber;
					percentCallback(clearPercentCounter.curNumber);
				}
			},

			onComplete: _ -> {
				// Play confirm sound.
				if (rank != ScoringRank.SHIT) {
					FlxG.sound.play(Paths.sound("confirmMenu"), 1).pitch = 1.05;
				} else {
					FlxG.sound.play(Paths.sound("confirmMenu"), 1).pitch = 0.5;
				}

				// Just to be sure that the lerp didn't mess things up.
				clearPercentCounter.curNumber = clearPercentTarget;

				clearPercentCounter.flash(true);
				new FlxTimer().start(0.4, _ -> {
					clearPercentCounter.flash(false);
					FlxTween.tween(clearPercentCounter, {x: 940, y: 550}, 1, {startDelay: 0.25, ease: FlxEase.quintInOut});
					
					if (resultsCharacter != null) {
						if (FreeplayState.freeplayCharacter == 'c3jo') {
							resultsCharacter.visible = true;
							FlxTween.tween(resultsCharacter, {x: charGoToX}, 1.8, {ease: FlxEase.expoOut, startDelay: 0.25});
							
							if (rank != ScoringRank.SHIT) {
								resultsCharacter.animation.play('win', true);
								resultsCharacter.animation.finishCallback = function(name:String) {
									if (name == 'win') resultsCharacter.animation.play('idle', true);
								}
							} else {
								resultsCharacter.animation.play('lose', true);
								resultsCharacter.animation.finishCallback = function(name:String) {
									if (name == 'lose') resultsCharacter.animation.play('lose idle', true);
								}
							}
						}
						
						if (FreeplayState.freeplayCharacter == 'aquino') {
							if (rank != ScoringRank.SHIT) {
								resultsCharacter.animation.play('win', true);
								resultsCharacter.animation.curAnim.curFrame = 0;
								resultsCharacter.animation.curAnim.pause();
								resultsCharacter.animation.finishCallback = function(name:String) {
									if (name == 'win') resultsCharacter.animation.play('idle', true);
								}
								FlxTween.tween(resultsCharacter, {x: charGoToX}, 1.8, {ease: FlxEase.expoIn, startDelay: 0.35, onComplete: function(twn:FlxTween) {
									resultsCharacter.visible = true;
									resultsCharacter.animation.curAnim.resume();
								}});
							} else {
								FlxTween.tween(resultsCharacter, {x: charGoToX}, 1.8, {ease: FlxEase.expoOut, startDelay: 0.25});
								resultsCharacter.visible = true;
								resultsCharacter.animation.play('lose', true);
							}
						}
					}
				});
			}
		});

		if (ratingsPopin == null) {
			trace("Could not build ratingsPopin!");
		} else {
			ratingsPopin.animation.finishCallback = anim -> {
				if (params.isNewHighscore ?? false) {
					highscoreNew.visible = true;
					highscoreNew.animation.play("new");
				} else {
					highscoreNew.visible = false;
				}
			};
		}
	}

	function displayRankText():Void {
		bgFlash.visible = true;
		bgFlash.alpha = 1;
		FlxTween.tween(bgFlash, {alpha: 0}, 14 / 24);

		var rankTextVert:FlxBackdrop = new FlxBackdrop(Paths.image(rank.getVerTextAsset()), Y, 0, 30);
		rankTextVert.x = FlxG.width - 44;
		rankTextVert.y = 100;
		add(rankTextVert);

		FlxFlicker.flicker(rankTextVert, 2 / 24 * 3, 2 / 24, true);

		// Scrolling.
		new FlxTimer().start(30 / 24, _ -> {
			rankTextVert.velocity.y = -80;
		});

		for (i in 0...12) {
			var rankTextBack:FlxBackdrop = new FlxBackdrop(Paths.image(rank.getHorTextAsset()), X, 10, 0);
			rankTextBack.x = FlxG.width / 2 - 320;
			rankTextBack.y = 50 + (135 * i / 2) + 10;
			rankTextBack.cameras = [cameraScroll];
			add(rankTextBack);

			rankTextBack.velocity.x = (i % 2 == 0) ? -7.0 : 7.0;
		}
	}

	function afterRankTallySequence():Void {
		showSmallClearPercent();
	}

	function timerThenSongName(timerLength:Float = 3.0, autoScroll:Bool = true):Void
	{
		movingSongStuff = false;
		difficulty.x = 555;

		var diffYTween:Float = 122;

		difficulty.y = -difficulty.height;
		FlxTween.tween(difficulty, {y: diffYTween}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.8});

		if (clearPercentSmall != null) {
			clearPercentSmall.x = (difficulty.x + difficulty.width) + 50;
			clearPercentSmall.y = -clearPercentSmall.height;
			FlxTween.tween(clearPercentSmall, {y: 122 - 5}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.85});
		}

		songName.y = -songName.height + 20;
		var fuckedupnumber = (10) * (songName.text.length / 15);
		FlxTween.tween(songName, {y: diffYTween - 25 - fuckedupnumber}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.9});
		songName.x = clearPercentSmall.x + 94;

		new FlxTimer().start(timerLength, _ -> {
			var tempSpeed = FlxPoint.get(speedOfTween.x, speedOfTween.y);

			speedOfTween.set(0, 0);
			FlxTween.tween(speedOfTween, {x: tempSpeed.x, y: tempSpeed.y}, 0.7, {ease: FlxEase.quadIn});

			movingSongStuff = (autoScroll);
		});
	}

	function showSmallClearPercent():Void
	{
		if (clearPercentSmall != null)
		{
			clearPercentSmall.visible = true;
			clearPercentSmall.flash(true);
			//FlxG.sound.play(Paths.sound("confirmMenu"), 1).pitch = 1.05;

			new FlxTimer().start(0.4, _ -> {
				clearPercentSmall.flash(false);
			});

			clearPercentSmall.curNumber = clearPercentTarget;
		}

		new FlxTimer().start(2.5, _ -> {
			movingSongStuff = true;
		});
	}

	var movingSongStuff:Bool = false;
	var speedOfTween:FlxPoint = FlxPoint.get(-1, 1);

	override function draw():Void {
		super.draw();
		songName.clipRect = FlxRect.get(Math.max(0, 520 - songName.x), 0, FlxG.width, songName.height);
	}

	var counterPitch:Float = 1;
	function playCounterSoundTickUp():Void{
		FlxG.sound.play(Paths.sound("scrollMenu"), 1).pitch = counterPitch;
		counterPitch += 1/12;
	}

	function percentCallback(value:Float):Void{
		value = (value/100) + 1;
		if(!exiting){ FlxG.sound.play(Paths.sound("scrollMenu"), 0.5).pitch = value; }
	}

	override function update(elapsed:Float):Void
	{
		maskShaderDifficulty.swagSprX = difficulty.x;

			if (movingSongStuff) {
			var deltaScale = elapsed * 190; //? fix framerate
			songName.x += speedOfTween.x*deltaScale;
			difficulty.x += speedOfTween.x*deltaScale;
			clearPercentSmall.x += speedOfTween.x*deltaScale;
			songName.y += speedOfTween.y*deltaScale;
			difficulty.y += speedOfTween.y*deltaScale;
			clearPercentSmall.y += speedOfTween.y*deltaScale;

			if (songName.x + songName.width < 100) timerThenSongName();
		}

		if (controls.ACCEPT || FlxG.mouse.justPressedRight && !exiting && shownRank) {
			exiting = true;
			if (FlxG.sound.music != null) {
				FlxTween.tween(FlxG.sound.music, {volume: 0}, 0.8);
				FlxTween.tween(FlxG.sound.music, {pitch: 3}, 0.1, {
					onComplete: _ -> {
						FlxTween.tween(FlxG.sound.music, {pitch: 0.5}, 0.4);
					}
				});
			}

			var stickerSet = 'stickers-set-wbns';
			var stickerPack = 'all';

			if (PlayState.SONG.player1.contains('c3jo')) {
				stickerSet = 'stickers-set-c3jo';

				stickerPack = switch (PlayState.SONG.song.toLowerCase()) {
					case "hiper": "hiper";
					case "roier": "roier";
					case "steyb": "steyb";
					case "noticiero": "umad";
					default: "all";
				};
			}

			if (PlayState.SONG.player1.contains('aquino')) {
				stickerSet = 'stickers-set-aquino';

				stickerPack = switch (PlayState.SONG.song.toLowerCase()) {
					case "erika": "erika";
					case "karfall": "karfall";
					case "noobly": "noobly";
					case "creisi.mov": "creisi";
					case "promenade": "botsita";
					case "let's go compota v2": "compota";
					case "saludo v2": "fernan";
					case "toneando v2": "adrian";
					case "estupidez": "estupidez";
					case "sylvee": "sylvee";
					default: "all";
				};
			}

			if (params.storyMode) {
				FlxG.sound.pause(); 
				StickerSubState.STICKER_SET = stickerSet;
				StickerSubState.STICKER_PACK = stickerPack;

				openSubState(cast new StickerSubState(null, _ -> new StoryMenuState()));
			} else {
				if (rank > params.prevScoreRank) {
					StickerSubState.STICKER_SET = stickerSet;
					StickerSubState.STICKER_PACK = stickerPack;
					openSubState(cast new StickerSubState(null, (sticker) -> new FreeplayState(sticker)));
				} else {
					FlxG.sound.pause(); //? fix sound
					StickerSubState.STICKER_SET = stickerSet;
					StickerSubState.STICKER_PACK = stickerPack;
					openSubState(cast new StickerSubState(null, (sticker) -> new FreeplayState(sticker)));
				}
			}
		}

		super.update(elapsed);
	}
}

typedef ResultsStateParams =
{
	var storyMode:Bool;
	var title:String;
	var songId:String;
	var ?isNewHighscore:Bool;
	var ?difficultyId:String;
	var scoreData:SaveScoreData;
	var prevScoreRank:ScoringRank;
};

typedef SaveScoreData =
{
	var score:Int;
	var accPoints:Float;
	var sick:Int;
	var good:Int;
	var bad:Int;
	var shit:Int;
	var missed:Int;
	var combo:Int;
	var maxCombo:Int;
	var totalNotesHit:Int;
	var totalNotes:Int;
}