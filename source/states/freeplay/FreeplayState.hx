package states.freeplay;

import flixel.graphics.FlxGraphic;
import flixel.addons.display.FlxBackdrop;

import shaders.ColorTint;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import substates.StickerSubState;
import substates.ResetScoreSubState;
import substates.GameplayChangersSubstate;

import objects.freeplay.FreeplayCapsule;
import objects.freeplay.FreeplayScore;
import objects.AudioDisplay;

import states.freeplay.FreeplayUtil;
import states.freeplay.FreeplayPreview;
import states.freeplay.FreeplayPreloadSubState;

class FreeplayState extends MusicBeatState {

    var songs:Array<SongMetadata> = [];
    var songsFreeplayMeta:Array<FreeplayMetadata> = [];
    var grpCapsules:FlxTypedGroup<FreeplayCapsule>;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	public var fpScore:FreeplayScore;
	public static var freeplayCharacter:String = 'bf'; // Later to be used for character selection
	private static var lastDifficultyName:String = Difficulty.getDefault();
	private var previewSong:FreeplayPreview;

    var bg:FlxSprite;
	var titleBack:FlxSprite;
    var freeplayTitle:FlxSprite;
	var titleSec:FlxSprite;
	var sprDifficulty:FlxSprite;
	var extraCharFP:FlxSprite;

	var missingTextBG:FlxSprite;
	var missingTextBox:FlxSprite;
	var missingText:FlxText;
	var missingTextTimer:FlxTimer;

	var completitionText:FlxText;
	var lerpScore:Float = 0;
	var lerpCompletition:Float = 0;
	var intendedScore:Int = 0;
	var intendedCompletion:Float = 0;

	var menuSongTime:Float = 0;
	var stickerSubState:StickerSubState;

	var visualizer:AudioDisplay;
	var bottomText:FlxText;
	var bottomBG:FlxSprite;

	var tintShader:ColorTint = null;

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

		WeekData.weeksList = [];
		WeekData.weeksLoaded.clear();

        DiscordClient.changePresence("In the Freeplay Menu", null, 'duxomadness');

		if (FreeplaySections.sectionSelected == '' || FreeplaySections.sectionSelected == null) {
			trace('Freeplay section is null!!!!\nExitting to FreeplaySections...');
			MusicBeatState.switchState(new FreeplaySections());
		}

		if (FlxG.sound.music != null) menuSongTime = FlxG.sound.music.time;
		WeekData.addByDirectory(Paths.getSharedPath('weeks/${FreeplaySections.sectionSelected}'));

		for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];

			for (j in 0...leWeek.songs.length) leSongs.push(leWeek.songs[j][0]);

			WeekData.setDirectoryFromWeek(leWeek);

            for (song in leWeek.songs) {
                addSong(song[0], i, song[1]);
            }
		}

		if (ClientPrefs.data.spookyUnlock) addSong('Trick or Treat', songs.length - 1, 'icon-spooky');

		Mods.loadTopMod();
		persistentUpdate = true;

		var bgStars:FlxBackdrop = new FlxBackdrop(Paths.image('ui/menus/utils/stars'));
		bgStars.velocity.set(10, 0);
		bgStars.antialiasing = ClientPrefs.data.antialiasing;
		add(bgStars);

		visualizer = new AudioDisplay(FlxG.sound.music, 0, 50, 2, 580, 40, 4, FlxColor.WHITE, false, true, true);
		visualizer.alpha = 0.75;
		visualizer.color = 0xFFFF0000;
		visualizer.changeAnalyzer(FlxG.sound.music);
		add(visualizer);
        
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/songs/titles/playable_characters_background'));
        bg.screenCenter();
        bg.x += 300;
        add(bg);

		Difficulty.resetList();
		if(lastDifficultyName == '')
			lastDifficultyName = Difficulty.getDefault();

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

        grpCapsules = new FlxTypedGroup<FreeplayCapsule>();
		add(grpCapsules);

		titleBack = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/songs/titles/freeplay title back'));
        titleBack.antialiasing = ClientPrefs.data.antialiasing;
        add(titleBack);

		freeplayTitle = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/tab/freeplay_title'));
		freeplayTitle.screenCenter();
		freeplayTitle.x -= 450;
		freeplayTitle.y -= 300;
        freeplayTitle.antialiasing = ClientPrefs.data.antialiasing;
        add(freeplayTitle);

		titleSec = new FlxSprite(0, 0);
		if (FreeplaySections.sectionSelected.contains('dlc'))
			titleSec.loadGraphic(Paths.image('freeplay/title_dlc'));
		else
			titleSec.loadGraphic(Paths.image('ui/menus/freeplay/songs/titles/title_${FreeplaySections.sectionSelected}'));

		titleSec.scale.set(2.2, 2.2);
		titleSec.updateHitbox();
		titleSec.x = 342.5;
		titleSec.y = 23.5;
		add(titleSec);

        bottomBG = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomBG.alpha = 0.6;
		add(bottomBG);

		var leText:String = Language.getPhrase(
            'freeplay_tip', 
            '[${ClientPrefs.keyBinds.get('ui_left')[0]}]/[${ClientPrefs.keyBinds.get('ui_left')[1]}] Difficulty left | [${ClientPrefs.keyBinds.get('ui_right')[0]}]/[${ClientPrefs.keyBinds.get('ui_right')[1]}] Difficulty Right | [${ClientPrefs.keyBinds.get('ui_up')[0]}]/[${ClientPrefs.keyBinds.get('ui_up')[1]}] Move Up | [${ClientPrefs.keyBinds.get('ui_down')[0]}]/[${ClientPrefs.keyBinds.get('ui_down')[1]}] Move Down | [${ClientPrefs.keyBinds.get('accept')[0]}]/[${ClientPrefs.keyBinds.get('accept')[1]}] Confirm selection'
        );
		var size:Int = 16;
		bottomText = new FlxText(0, bottomBG.y + 4, FlxG.width, leText, size);
		bottomText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), size, FlxColor.WHITE, CENTER);
		bottomText.scrollFactor.set();
        bottomText.antialiasing = ClientPrefs.data.antialiasing;
		add(bottomText);

		var difficultyBack:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/songs/difficults/dificult_back'));
		difficultyBack.antialiasing = ClientPrefs.data.antialiasing;
		difficultyBack.screenCenter();
		difficultyBack.x -= 380;
		difficultyBack.y += 280;
		add(difficultyBack);

		sprDifficulty = new FlxSprite(difficultyBack.x - 20, difficultyBack.y + 20);
		sprDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		add(sprDifficulty);

		generateSongCapsules(true);
		WeekData.setDirectoryFromWeek();

		var scoreBack:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/menus/freeplay/songs/score/highscore'));
		scoreBack.screenCenter();
		scoreBack.x = 880;
		scoreBack.y = 33;
		scoreBack.antialiasing = ClientPrefs.data.antialiasing;
		add(scoreBack);

		fpScore = new FreeplayScore(scoreBack.x - 391, scoreBack.y + 14, 7, 100);
		fpScore.updateScore(0);
		add(fpScore);

		completitionText = new FlxText(scoreBack.x + 295, 55, "0", 25);
		completitionText.setFormat(Paths.font("4x4kanafont.ttf"), 20, FlxColor.WHITE, LEFT);
		completitionText.antialiasing = false;
		add(completitionText);

		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		add(missingTextBG);
		
		missingTextBox = new FlxSprite().makeGraphic(1200, 500, 0xFF121227);
		missingTextBox.screenCenter();
		missingTextBox.alpha = 0.8;
		missingTextBox.visible = false;
		add(missingTextBox);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("m6x11plus.ttf"), 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK); // hmmmm balatro font
		missingText.scrollFactor.set();
		missingText.visible = false;
		missingText.antialiasing = ClientPrefs.data.antialiasing;
		add(missingText);

		tintShader = new ColorTint();
		tintShader.uMix = 0.8;

		if (tintShader != null) {
			bg.shader = freeplayTitle.shader = scoreBack.shader = tintShader.shader;
		}

		changeSelection();
		updateCapsulePositions(0);
		bottomTextMove();
		super.create();
		
		freeplayPreload(songs);
    }

	function freeplayPreload(preloadList:Array<SongMetadata>) {
		var preloadSongList = [for (song in preloadList) { name: song.songName }];
		persistentUpdate = false;
		
		if (stickerSubState == null || stickerSubState.stickersGone) {
			openSubState(new FreeplayPreloadSubState(preloadSongList));
		}
	}

	var moveTimer:FlxTimer = new FlxTimer();
    var moveTween:FlxTween;
	function bottomTextMove():Void {
		moveTween = FlxTween.tween(bottomText, {x: 1300}, 16, {
			ease: FlxEase.smoothStepOut,
			startDelay: 0.8,
			onComplete: function(_) {
				moveTimer.start(2, (timer) -> {
					bottomText.x = -680;
					bottomTextMove();
				});
			},
		});
	}

    public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

    function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

    var movedBack:Bool = false;
	var holdTime:Float = 0;
	var canSelectSomething = true;
	var toResetState:Bool = false;

    override function update(elapsed:Float):Void {
        super.update(elapsed);

		lerpScore = MathUtil.smoothLerp(lerpScore, intendedScore, elapsed, 0.5);
		lerpCompletition = MathUtil.smoothLerp(lerpCompletition, intendedCompletion, elapsed, 0.5);

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpCompletition - intendedCompletion) <= 0.01)
			lerpCompletition = intendedCompletion;

		completitionText.text = '${Math.floor(lerpCompletition)}';
		updateCapsulePositions(elapsed);
		
		//Right align the completion percentage
		switch (completitionText.text.length) {
			case 3:
				completitionText.offset.x = -10;
			case 2:
				completitionText.offset.x = -30;
			case 1:
				completitionText.offset.x = -50;
			default:
				completitionText.offset.x = -50;
		}

		// #if debug
		// if (FlxG.keys.pressed.ALT) {
		// 	if (controls.UI_LEFT_P) {
		// 		trace('To 0');
		// 		FlxTween.cancelTweensOf(mmMenuShader);
		// 		FlxTween.num(0, 1, 1.5, {ease: FlxEase.smoothStepOut}, function(num:Float) {
		// 			mmMenuShader.uMix.value = [num];
		// 			trace('uMix = ${mmMenuShader.uMix.value[0]}');
		// 		});
		// 	}

		// 	if (controls.UI_RIGHT_P) {
		// 		trace('To 1');
		// 		FlxTween.cancelTweensOf(mmMenuShader);
		// 		FlxTween.num(1, 0, 1.5, {ease: FlxEase.smoothStepOut}, function(num:Float) {
		// 			mmMenuShader.uMix.value = [num];
		// 			trace('uMix = ${mmMenuShader.uMix.value[0]}');
		// 		});
		// 	}
		// }
		// #end
		
		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT) shiftMult = 3;

		fpScore.updateScore(Std.int(lerpScore));

		if (canSelectSomething) {
			if(FlxG.keys.justPressed.HOME) {
				curSelected = 0;
				changeSelection();
				holdTime = 0;	
			} else if(FlxG.keys.justPressed.END) {
				curSelected = grpCapsules.length - 1;
				changeSelection();
				holdTime = 0;	
			}

			if (controls.UI_UP_P) {
				changeSelection(-shiftMult);
				holdTime = 0;
			}
	
			if (controls.UI_DOWN_P) {
				changeSelection(shiftMult);
				holdTime = 0;
			}
	
			if (controls.UI_DOWN || controls.UI_UP) {
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
	
				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}
	
			if(FlxG.mouse.wheel != 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel);
			}

			if (controls.UI_RIGHT_P) {
				changeDiff(1); 
				generateSongCapsules(true);
			} else if (controls.UI_LEFT_P) {
				changeDiff(-1); 
				generateSongCapsules(true);
			}
	
			if (controls.ACCEPT) {
				FlxG.sound.play(Paths.sound('confirm'), 0.5);
				grpCapsules.members[curSelected].onConfirm();
				canSelectSomething = false;
			} else if (controls.RESET) {
				persistentUpdate = false;
				toResetState = true;
				openSubState(new ResetScoreSubState(grpCapsules.members[curSelected].songText.text, curDifficulty, grpCapsules.members[curSelected].icon.char));
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if (stickerSubState == null || stickerSubState.stickersGone) {
				if (FlxG.keys.justPressed.CONTROL) {
					persistentUpdate = false;
					openSubState(new GameplayChangersSubstate());
				}
			}
	
			if (controls.BACK) {
				if (previewSong != null) {
					if (FlxG.sound.music != null) FlxG.sound.music.stop();
					previewSong.isLooping = false;
				}
				
				movedBack = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));

				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.fadeIn(1.5, 0, 1);
				FlxG.sound.music.time = menuSongTime;
				
				MusicBeatState.switchState(new FreeplaySections());
			}
		}

		if (FlxG.keys.pressed.SHIFT) {
			if (FlxG.keys.justPressed.SPACE) {
			   var curCapsule:FreeplayCapsule = grpCapsules.members[curSelected];
			   if (curCapsule.songText.text == 'Random') {
				   var availableSongCapsules:Array<FreeplayCapsule> = grpCapsules.members.filter(function(cap:FreeplayCapsule) {
					   return cap != null && cap.alive;
				   });
   
				   var randomCapsule:FreeplayCapsule = FlxG.random.getObject(availableSongCapsules, null, 1);
				   var songName:String = randomCapsule.songText.text;
				   if (songName != 'Random') {
					   var meta:FreeplayMetadata = FreeplayUtil.getMeta(songName);
					   
					   if (previewSong != null) {
						   if (FlxG.sound.music != null) FlxG.sound.music.stop();
						   previewSong.isLooping = false;
					   }
	   
					   var params:PlayerParams = {
						   isInst: true,
						   loop: true,
						   startingVolume: 0.0,
						   starting: meta.freeplayPrevStart,
						   ending: meta.freeplayPrevEnd,
						   onLoad: function() {
							   Conductor.bpm = meta.startingBPM;
							   FlxG.sound.music.fadeIn(2, 0.0, 0.8);
						   }
					   };
					   previewSong = new FreeplayPreview(params);
					   previewSong.play(songName);
				   } else {
					   var params:PlayerParams = {
						   isInst: false,
						   loop: true,
						   startingVolume: 0.0,
						   onLoad: function() {
							   Conductor.bpm = 146;
							   FlxG.sound.music.fadeIn(2, 0.0, 0.8);
							   visualizer.changeAnalyzer(FlxG.sound.music);
						   }
					   };
   
					   previewSong = new FreeplayPreview(params);
					   previewSong.play("freeplayRandom");
				   }
			   }
		   }
		}

		Conductor.songPosition = FlxG.sound.music.time;
		if (previewSong != null) previewSong.update(elapsed);
    }

	override function closeSubState() {
		super.closeSubState();

		if (!movedBack && toResetState) {
			toResetState = false;
			generateSongCapsules(true);
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (grpCapsules.countLiving() > 1) {
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		} else {
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.8);
		}

		if (missingTextTimer != null) missingTextTimer.cancel();
		for (obj in [missingText, missingTextBox, missingTextBG]) {
			if (obj != null) obj.visible = false;
		}
		
		if (curSelected < 0) curSelected = grpCapsules.countLiving() - 1;
		if (curSelected >= grpCapsules.countLiving()) curSelected = 0;

		if (songs[curSelected-1] != null) {
			Mods.currentModDirectory = songs[curSelected-1].folder;
			PlayState.storyWeek = songs[curSelected-1].week;
		}

		changeDiff();
		playTargetSong();
	}

	var tweenDifficulty:FlxTween;
	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		
		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		if (missingTextTimer != null) missingTextTimer.cancel();

		for (obj in [missingText, missingTextBox, missingTextBG]) {
			if (obj != null) obj.visible = false;
		}

		lastDifficultyName = Difficulty.getString(curDifficulty);
		var newImage:FlxGraphic = Paths.image('ui/menus/freeplay/songs/difficults/dificult_${lastDifficultyName.toLowerCase()}');

		var curCapsule:FreeplayCapsule = grpCapsules.members[curSelected];
		if (curCapsule != null) {
			intendedScore = Highscore.getScore(grpCapsules.members[curSelected].songText.text, curDifficulty);
			intendedCompletion = Highscore.getCompletition(grpCapsules.members[curSelected].songText.text, curDifficulty);
		} else { 
			intendedScore = 0;
			intendedCompletion = 0;
		}

		if (sprDifficulty.graphic != newImage) {
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.alpha = 0;
			sprDifficulty.y = sprDifficulty.y - 15;

			if (tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: sprDifficulty.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
	}

	function playTargetSong() {
		var songName:String = grpCapsules.members[curSelected].songText.text;
		if (songName != 'Random') {
			var meta:FreeplayMetadata = FreeplayUtil.getMeta(songName);
			
			if (previewSong != null) {
				if (FlxG.sound.music != null) FlxG.sound.music.stop();
				previewSong.isLooping = false;
			}

			var params:PlayerParams = {
				isInst: true,
				loop: true,
				startingVolume: 0.0,
				starting: meta.freeplayPrevStart,
				ending: meta.freeplayPrevEnd,
				onLoad: function() {
					Conductor.bpm = meta.startingBPM;
					FlxG.sound.music.fadeIn(2, 0.0, 0.8);
				}
			};
			previewSong = new FreeplayPreview(params);
			previewSong.play(songName);
		} else {
			if (previewSong != null) {
				if (FlxG.sound.music != null) FlxG.sound.music.stop();
				previewSong.isLooping = false;
			}

			var params:PlayerParams = {
				isInst: false,
				loop: true,
				startingVolume: 0.0,
				onLoad: function() {
					Conductor.bpm = 146;
					FlxG.sound.music.fadeIn(2, 0.0, 0.8);
					visualizer.changeAnalyzer(FlxG.sound.music);
				}
			};
			previewSong = new FreeplayPreview(params);
			FreeplayPreview.preloadSound("freeplayRandom", false, function(){ previewSong.play("freeplayRandom"); });
		}
	}

	function updateCapsulePositions(elapsed:Float):Void {
		var midIndex:Int = Math.floor(grpCapsules.members.length / 2);
		var offset:Int = curSelected - midIndex;

		for (index in 0...grpCapsules.members.length) {
			var capsule:FreeplayCapsule = grpCapsules.members[index];
			var newIndex:Int = index - offset;
			var yOffset:Float = (newIndex - midIndex) * 220;
			var xPos:Float = 20 + (100 * (Math.sin((newIndex - midIndex) - 150)));

			capsule.targetPos.y = capsule.intendedY(newIndex - midIndex);
			capsule.targetPos.x = FlxMath.lerp(xPos, capsule.x, Math.exp(-FlxG.elapsed * 10.2));
			capsule.forcePosition();

			if (newIndex < 0) newIndex += grpCapsules.members.length;
			if (newIndex >= grpCapsules.members.length) newIndex -= grpCapsules.members.length;

			capsule.selected = newIndex == midIndex;
			capsule.alpha = (newIndex == midIndex) ? 1 : 0.6;
			capsule.capsule.animation.play((newIndex == midIndex) ? 'unlocked' : 'locked');
		}
	}

	function generateSongCapsules(intro:Bool = false):Void {
		var tempSongListArray:Array<SongMetadata> = songs;
		tempSongListArray = tempSongListArray.filter(song -> {
			if (song == null) return true;

			var songDifficulties:Array<String> = FreeplayUtil.getSongDifficulties(song.songName);
			return songDifficulties.contains(Difficulty.getString(curDifficulty).toLowerCase());
		});

		grpCapsules.clear();
		grpCapsules.killMembers();

		// Random capsule
		var randomCapsule:FreeplayCapsule = grpCapsules.recycle(FreeplayCapsule);
		randomCapsule.init(-1350, 0, 'Random', 'bf', freeplayCharacter);
		randomCapsule.y = randomCapsule.intendedY(0) - 10;
		randomCapsule.targetPos.x = randomCapsule.x;
		randomCapsule.newText.visible = false;
		randomCapsule.favIcon.visible = false;
		randomCapsule.icon.visible = false;
		randomCapsule.onConfirm = function() {
			capsuleOnConfirmRandom(randomCapsule);
		};
		randomCapsule.checkClip();
		grpCapsules.add(randomCapsule);

		// Song capsule
		for (i in 0...tempSongListArray.length) {
			var songCapsules:FreeplayCapsule = grpCapsules.recycle(FreeplayCapsule);
			songCapsules.init(-1350, 0, tempSongListArray[i].songName, tempSongListArray[i].songCharacter, freeplayCharacter);
			songCapsules.y = songCapsules.intendedY(i + 1) - 10;
			songCapsules.targetPos.x = songCapsules.x;
			songCapsules.newText.visible = Highscore.isSongBeated(tempSongListArray[i].songName, curDifficulty);
			songCapsules.favIcon.visible = ClientPrefs.isSongFavorited(tempSongListArray[i].songName.toLowerCase());
			songCapsules.ranking.rank = Highscore.getSongRank(tempSongListArray[i].songName, curDifficulty);
			songCapsules.onConfirm = function() {
				onCapsuleConfirm(songCapsules);
			};
			songCapsules.checkClip();
			grpCapsules.add(songCapsules);
		}

		WeekData.setDirectoryFromWeek();
		changeSelection();
	}

	function onCapsuleConfirm(capsule:FreeplayCapsule):Void {
		capsule.confirm();
		
		persistentUpdate = false;
		var songLowercase:String = Paths.formatToSongPath(grpCapsules.members[curSelected].songText.text);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

		trace(poop);

		try {
			if (FreeplaySections.sectionSelected.contains('dlc'))
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			else 
				PlayState.SONG = Song.loadFromJson(poop, '${FreeplaySections.sectionSelected}/${songLowercase}');
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
		} catch (e:Dynamic) {
			trace('ERROR! $e');
			grpCapsules.members[curSelected].capsule.animation.play('unlocked');

			var errorStr:String = e.toString();
			if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(22, errorStr.length-1); //Missing chart

			if (missingTextTimer != null) missingTextTimer.cancel();
			
			for (obj in [missingText, missingTextBox, missingTextBG]) {
				if (obj != null) obj.visible = true;
			}
			
			if (missingText != null) {
				missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
				missingText.screenCenter(Y);
			}

			missingTextTimer = new FlxTimer().start(3, function(tmr:FlxTimer) {
				for (obj in [missingText, missingTextBox, missingTextBG]) {
					if (obj != null) obj.visible = false;
				}
				canSelectSomething = true;
			});
			return;
		}

		new FlxTimer().start(1.5, function(tmr:FlxTimer) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			LoadingState.prepareToSong();
			LoadingState.loadAndSwitchState(new PlayState());
		});
	}

	function capsuleOnConfirmRandom(capsule:FreeplayCapsule):Void {
		trace('Random capsule selected!');
	
		if (grpCapsules == null || grpCapsules.members == null || grpCapsules.members.length == 0) {
			trace('Error: grpCapsules no está inicializado o está vacío.');
			FlxG.sound.play(Paths.sound('cancelMenu'));
			return;
		}
	
		var availableSongCapsules:Array<FreeplayCapsule> = grpCapsules.members.filter(function(cap:FreeplayCapsule) {
			return cap != null && cap.alive;
		});
	
		if (availableSongCapsules == null || availableSongCapsules.length <= 1) {
			trace('No songs available!');
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.resetState();
			return;
		}
	
		var targetSong:FreeplayCapsule = FlxG.random.getObject(availableSongCapsules);
		if (targetSong == null) {
			trace('No se pudo seleccionar una cápsula aleatoria.');
			FlxG.sound.play(Paths.sound('cancelMenu'));
			return;
		}
	
		curSelected = grpCapsules.members.indexOf(targetSong);
		if (curSelected == -1) {
			trace('Error: La cápsula seleccionada no se encuentra en grpCapsules.');
			return;
		}
	
		changeSelection();
		updateCapsulePositions(0);
		onCapsuleConfirm(targetSong);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}