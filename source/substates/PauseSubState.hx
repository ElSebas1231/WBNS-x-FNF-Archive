package substates;

import backend.WeekData;
import backend.Highscore;
import backend.Song;

import flixel.addons.transition.FlxTransitionableState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxStringUtil;

import states.StoryMenuState;
import states.freeplay.FreeplayState;
import states.freeplay.FreeplayUtil;
import states.freeplay.FreeplaySections;

import options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Options', 'Exit to menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);

	var missingTextBG:FlxSprite;
	var missingText:FlxText;

	var creditsBox:FlxSprite;
	var creditsBoxTxt:FlxText;

    var contextBox:FlxSprite;
	var contextBoxTxt:FlxText;

	var mainBG:FlxSprite;
    var header:FlxSprite;
    var infoText:FlxText;
    var songNameText:FlxText;

    var entrySpacing:Int = 120;
    var noticeOpened:Bool = false;

    var songNameTxtBG:FlxSprite;
    var infoTextBG:FlxSprite;

    var noticeDateText:FlxText;
    var noticeTitleText:FlxText;
    var noticeBodyGroup:FlxTypedGroup<FlxText>;
    var noticePadding:Int = 16;

    var showMessage:Bool = false;
	public static var songName:String = null;

	var creditsTxt:String;
	var contextTxt:String;

	override function create()
	{
		Cursor.show();

		if(Difficulty.list.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
			}
			menuItemsOG.insert(3 + num, 'End Song');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		difficultyChoices = FreeplayUtil.getSongDifficulties(PlayState.SONG.song);
		difficultyChoices.push('BACK');

		var meta:FreeplayMetadata = FreeplayUtil.getMeta(PlayState.SONG.song);
		creditsTxt = (meta.songCredits != null ? meta.songCredits : '???');
		contextTxt = (meta.songContext != null ? meta.songContext : '???');

		pauseMusic = new FlxSound();
		try {
			var pauseSong:String = getPauseSong();
			if(pauseSong != null) pauseMusic.loadEmbedded(Paths.music(pauseSong), true, true);
		}
		catch(e:Dynamic) {}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 16, 0, PlayState.SONG.song, 32);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelInfo.updateHitbox();
		levelInfo.borderSize = 2;
		levelInfo.antialiasing = ClientPrefs.data.antialiasing;
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, levelInfo.y + 32, 0, Difficulty.getString().toUpperCase(), 32);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelDifficulty.borderSize = 2;
		levelDifficulty.updateHitbox();
		levelDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, levelInfo.y + 64, 0, "Blueballed: " + PlayState.deathCounter, 32);
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		blueballedTxt.borderSize = 2;
		blueballedTxt.updateHitbox();
		blueballedTxt.antialiasing = ClientPrefs.data.antialiasing;
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		practiceText.borderSize = 2;
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		practiceText.antialiasing = ClientPrefs.data.antialiasing;
		add(practiceText);

		var chartingText:FlxText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.borderSize = 2;
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		chartingText.antialiasing = ClientPrefs.data.antialiasing;
		add(chartingText);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		if (creditsTxt != null && creditsTxt.length > 0) {
			creditsBox = new FlxSprite(1080, 140).loadGraphic(Paths.image('ui/menus/utils/pauseButton'));
			creditsBox.color = 0xFF00ff00;
			creditsBox.updateHitbox();
			add(creditsBox);

			creditsBoxTxt = new FlxText();
			creditsBoxTxt.text = 'Créditos';
			creditsBoxTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsBoxTxt.borderSize = 2;
			creditsBoxTxt.x = (creditsBox.width / 2) - (creditsBoxTxt.width / 2) + creditsBox.x;
			creditsBoxTxt.y = (creditsBox.height / 2) - (creditsBoxTxt.height / 2) + creditsBox.y;
			creditsBoxTxt.antialiasing = ClientPrefs.data.antialiasing;
			add(creditsBoxTxt);
		}

		if (contextTxt != null && contextTxt.length > 0) {
			contextBox = new FlxSprite(1080, (creditsBox == null ? 140 : 230)).loadGraphic(Paths.image('ui/menus/utils/pauseButton'));
			contextBox.color = 0xFF00ffff;
			contextBox.updateHitbox();
			add(contextBox);
	
			contextBoxTxt = new FlxText();
			contextBoxTxt.text = 'Contexto';
			contextBoxTxt.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			contextBoxTxt.borderSize = 2;
			contextBoxTxt.x = (contextBox.width / 2) - (contextBoxTxt.width / 2) + contextBox.x;
			contextBoxTxt.y = (contextBox.height / 2) - (contextBoxTxt.height / 2) + contextBox.y;
			contextBoxTxt.antialiasing = ClientPrefs.data.antialiasing;
			add(contextBoxTxt);
		}

        mainBG = new FlxSprite().makeGraphic(1366, 768, FlxColor.fromString("#330103"));
        mainBG.alpha = 0.7;
        add(mainBG);

        header = new FlxSprite().makeGraphic(1366, 80, FlxColor.fromString("#8f030a"));
        add(header);

        songNameTxtBG = new FlxSprite(30, 80).makeGraphic(1219, 77, FlxColor.fromString('#181818'));
        add(songNameTxtBG);

		songNameText = new FlxText(0, 0, 0, PlayState.SONG.song, 48);
        songNameText.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), 48, FlxColor.fromString("#ccc3c3"), "center");
        songNameText.antialiasing = ClientPrefs.data.antialiasing;
		songNameText.x = (songNameTxtBG.width / 2) - (songNameText.width / 2) + songNameTxtBG.x;
		songNameText.y = (songNameTxtBG.height / 2) - (songNameText.height / 2) + songNameTxtBG.y;
        add(songNameText);

        infoTextBG = new FlxSprite(30, 157).makeGraphic(1219, 550, FlxColor.fromString('#190d0e'));
        infoTextBG.alpha = 0.7;
        add(infoTextBG);

		infoText = new FlxText(0, 20, 0, '', 48);
        infoText.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), 48, FlxColor.fromString("#ccc3c3"), "center");
        infoText.antialiasing = ClientPrefs.data.antialiasing;
        add(infoText);

        noticeBodyGroup = new FlxTypedGroup<FlxText>();
        add(noticeBodyGroup);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		for (obj in [mainBG, header, songNameText, songNameTxtBG, infoText, infoTextBG, infoTextBG]) {
			obj.visible = false;
			obj.active = false;
		}

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.1});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.2});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.3});

		creditsBox.alpha = 0;
		creditsBoxTxt.alpha = 0;
		FlxTween.tween(creditsBox, {alpha: 1, y: creditsBox.y + 5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.3});
		FlxTween.tween(creditsBoxTxt, {alpha: 1, y: creditsBoxTxt.y + 5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.3});

		contextBox.alpha = 0;
		contextBoxTxt.alpha = 0;
		FlxTween.tween(contextBox, {alpha: 1, y: contextBox.y + 5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.3});
		FlxTween.tween(contextBoxTxt, {alpha: 1, y: contextBoxTxt.y + 5}, 0.4, {ease: FlxEase.quartOut, startDelay: 0.3});

		// Use the full-screen size directly instead of scaling a small graphic.
		missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		missingTextBG.updateHitbox();
		missingTextBG.alpha = 0.6;
		missingTextBG.visible = false;
		missingTextBG.scrollFactor.set();
		add(missingTextBG);
		
		missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
		missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missingText.scrollFactor.set();
		missingText.visible = false;
		add(missingText);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}
	
	function getPauseSong()
	{
		var formattedSongName:String = (songName != null ? Paths.formatToSongPath(songName) : '');
		var formattedPauseMusic:String = Paths.formatToSongPath(ClientPrefs.data.pauseMusic);
		if(formattedSongName == 'none' || (formattedSongName != 'none' && formattedPauseMusic == 'none')) return null;

		return (formattedSongName != '') ? formattedSongName : formattedPauseMusic;
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	var creditBoxHovered:Bool = false;
	var contextBoxHovered:Bool = false;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		mouseDetection();
		updateSkipTextStuff();

		if (!showMessage) {

			if(controls.BACK) {
				close();
				return;
			}

			if (controls.UI_UP_P) changeSelection(-1);
			if (controls.UI_DOWN_P) changeSelection(1);

			var daSelected:String = menuItems[curSelected];
			switch (daSelected)
			{
				case 'Skip Time':
					if (controls.UI_LEFT_P) {
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						curTime -= 1000;
						holdTime = 0;
					}
	
					if (controls.UI_RIGHT_P) {
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						curTime += 1000;
						holdTime = 0;
					}
	
					if(controls.UI_LEFT || controls.UI_RIGHT) {
						holdTime += elapsed;
						if (holdTime > 0.5) curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
	
						if (curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
						else if(curTime < 0) curTime += FlxG.sound.music.length;
						updateSkipTimeText();
					}
			}
	
			if (controls.ACCEPT && (cantUnpause <= 0 || !controls.controllerMode)) {
				if (menuItems == difficultyChoices) {
					try {
						if(menuItems.length - 1 != curSelected && difficultyChoices.contains(daSelected)) {
	
							var name:String = PlayState.SONG.song;
							var poop = Highscore.formatSong(name, curSelected);
							PlayState.SONG = Song.loadFromJson(poop, name);
							PlayState.storyDifficulty = curSelected;
							MusicBeatState.resetState();
							FlxG.sound.music.volume = 0;
							PlayState.changedDifficulty = true;
							PlayState.chartingMode = false;
							return;
						}					
					} catch(e:Dynamic){
						trace('ERROR! $e');
	
						var errorStr:String = e.toString();
						if (errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart
						missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
						missingText.screenCenter(Y);
						missingText.visible = true;
						missingTextBG.visible = true;
						FlxG.sound.play(Paths.sound('cancelMenu'));
	
						super.update(elapsed);
						return;
					}
	
	
					menuItems = menuItemsOG;
					regenMenu();
				}
	
				switch (daSelected) {
					case "Resume":
						close();
					case 'Change Difficulty':
						menuItems = difficultyChoices;
						deleteSkipTimeText();
						regenMenu();
					case 'Toggle Practice Mode':
						PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
						PlayState.changedDifficulty = true;
						practiceText.visible = PlayState.instance.practiceMode;
					case "Restart Song":
						restartSong(true);
						close();
					case "Leave Charting Mode":
						restartSong();
						PlayState.chartingMode = false;
					case 'Skip Time':
						if (curTime < Conductor.songPosition) {
							PlayState.startOnTime = curTime;
							restartSong(true);
						} else {
							if (curTime != Conductor.songPosition) {
								PlayState.instance.clearNotesBefore(curTime);
								PlayState.instance.setSongTime(curTime);
							}
							close();
						}
					case 'End Song':
						close();
						PlayState.instance.notes.clear();
						PlayState.instance.unspawnNotes = [];
						PlayState.instance.finishSong(true);
					case 'Toggle Botplay':
						PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
						PlayState.changedDifficulty = true;
						PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
						PlayState.instance.botplayTxt.alpha = 1;
						PlayState.instance.botplaySine = 0;
					case 'Options':
						PlayState.instance.paused = true; // For lua
						PlayState.instance.vocals.volume = 0;
						MusicBeatState.switchState(new OptionsState());
						if(ClientPrefs.data.pauseMusic != 'None') {
							FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), pauseMusic.volume);
							FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
							FlxG.sound.music.time = pauseMusic.time;
						}
						OptionsState.onPlayState = true;
					case "Exit to menu":
						#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
						PlayState.deathCounter = 0;
						PlayState.seenCutscene = false;
	
						Mods.loadTopMod();
	
						var stickerSet = 'stickers-set-dm';
						var stickerPack = switch (PlayState.SONG.song.toLowerCase()) {
							case "its a rat": "itsarat";
							case "last milk": "lastCourse";
							case "nightmare": "nightmare";
							case "sdlg": "sdlg";
							case "trick or treat": "trickOrTreat";
							case "tryhard slaughter": "tryhard";
							case "unwebonable v2": "unwebonable";
							case "all wbns": "duxoMadness";
							default: "all";
						};
						
						if (stickerSet != null) StickerSubState.STICKER_SET = stickerSet else StickerSubState.STICKER_SET = 'stickers-set-wbns';
						if (stickerPack != null) StickerSubState.STICKER_PACK = stickerPack else StickerSubState.STICKER_PACK = 'all';
						
						if (states.TitleState.secretSongLoaded) {
							FlxG.switchState(new FreeplaySections());
						} else {
							if (!ClientPrefs.data.noStickers) {
								if (PlayState.isStoryMode) {
									openSubState(cast new StickerSubState(null, _ -> new StoryMenuState()));
								} else {
									openSubState(cast new StickerSubState(null, (sticker) -> new FreeplayState(sticker)));
								}
							} else {
								if (PlayState.isStoryMode) {
									FlxG.switchState(new StoryMenuState());
								} else {
									FlxG.switchState(new FreeplayState());
								}
							}
						}

						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						PlayState.changedDifficulty = false;
						PlayState.chartingMode = false;
						FlxG.camera.followLerp = 0;
				}
			}
		}

		if (controls.BACK) {
			mouseDetection();
            if (showMessage) {
				clearNoticeBody();
				showMessage = false;
				for (obj in [mainBG, header, songNameText, songNameTxtBG, infoText, infoTextBG, infoTextBG]) {
					obj.visible = false;
					obj.active = false;
				}
            }
        }
	}

	function deleteSkipTimeText()
	{
		if (skipTimeText != null){
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if (noTrans) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		MusicBeatState.resetState();
	}

	override function destroy()
	{
		pauseMusic.destroy();
		Cursor.hide();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0) {
				item.alpha = 1;

				if(item == skipTimeTracker) {
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
		missingText.visible = false;
		missingTextBG.visible = false;
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.distancePerItem.x = 0;
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}

    function clearNoticeBody():Void {
        if (noticeBodyGroup != null) {
            for (t in noticeBodyGroup.members) {
                if (t != null) t.kill();
            }
            noticeBodyGroup.clear();
        }
    }

    function showNoticeDetail(title:String, txt:String):Void {
		clearNoticeBody();
		showMessage = true;

        var pad = noticePadding;
        var x = Std.int(infoTextBG.x + pad);
        var y = Std.int(infoTextBG.y + pad);
        var innerW = Std.int(infoTextBG.width - pad*2);
        var maxH = Std.int(infoTextBG.height - pad*2);

		infoText.text = title;
		infoText.x = (header.width / 2) - (infoText.width / 2) + header.x - 45;
		infoText.y = (header.height / 2) - (infoText.height / 2) + header.y;
		
        var blocks = parseMarkdownBlocks(txt);
        var cursorY = y;
        for (b in blocks) {
            var size = 18;
            var color = FlxColor.fromString("#ccc3c3");
            var align = "left";
            var prefix = "";

            switch (b.type) {
                case "h1":
                    size = 26;
                    color = FlxColor.fromString("#ccc3c3");
                case "h2":
                    if (b.type == "h2") size = 20;
                    color = FlxColor.fromString("#ccc3c3");
                case "li":
                    size = 18;
                    prefix = "• ";
                case "p":
                    size = 18;
            }

            var displayText = b.text;
            displayText = StringTools.replace(displayText, "**", "");
            displayText = StringTools.replace(displayText, "*", "");

            if (prefix != "") displayText = prefix + displayText;

            if (displayText.length == 0) {
                cursorY += 8;
            } else {
                var ft = new FlxText(x, cursorY, innerW, displayText, size);
                ft.setFormat(Paths.font('PhantomMuff Full Letters 1.1.5.ttf'), size, color, align);
                ft.antialiasing = ClientPrefs.data.antialiasing;
                noticeBodyGroup.add(ft);
                cursorY += Std.int(ft.height) + 6;
            }

            if (cursorY - y > maxH) {
                break;
            }
        }
    }

    static function parseMarkdownBlocks(md:String):Array<Dynamic> {
        if (md == null) return [];
        md = md.replace("\r\n", "\n");
        var lines = md.split("\n");
        var out = new Array<Dynamic>();

        for (line in lines) {
            var t = StringTools.trim(line);
            if (t.length == 0) {
                out.push({ type: "p", text: "" });
                continue;
            }

            if (t.charAt(0) == '#') {
                var lvl = 1;
                while (lvl < t.length && t.charAt(lvl) == '#') lvl++;
                var txt = StringTools.trim(t.substr(lvl));
                if (lvl == 1) out.push({ type: "h1", text: txt }); else out.push({ type: "h2", text: txt });
                continue;
            }

            if (t.charAt(0) == '-' || t.charAt(0) == '*' || t.charAt(0) == '+') {
                out.push({ type: "li", text: StringTools.trim(t.substr(1)) });
                continue;
            }

            out.push({ type: "p", text: t });
        }
        return out;
    }

	function mouseDetection() {
		var mouseWorldPos = FlxG.mouse.getWorldPosition(cameras[0]);
		
		if (creditsBox != null && creditsBox.overlapsPoint(mouseWorldPos, true, cameras[0])) {
			if (!creditBoxHovered) {
				creditBoxHovered = true;
			} else {
				if (!showMessage) Cursor.cursorMode = Pointer;
			}

			if (FlxG.mouse.justPressed) {
				if (!showMessage) {
					showNoticeDetail('Créditos', creditsTxt);
					for (obj in [mainBG, header, songNameText, songNameTxtBG, infoText, infoTextBG, infoTextBG]) {
						obj.visible = true;
						obj.active = true;
					}
					Cursor.cursorMode = Default;
				}
			}
		} else {
			if (creditBoxHovered) {
				creditBoxHovered = false;
				Cursor.cursorMode = Default;
			}
		}

		if (contextBox != null && contextBox.overlapsPoint(mouseWorldPos, true, cameras[0])) {
			if (!contextBoxHovered) {
				contextBoxHovered = true;
			} else {
				if (!showMessage) Cursor.cursorMode = Pointer;
			}
			
			if (FlxG.mouse.justPressed) {
				if (!showMessage) {
					showNoticeDetail('Contexto', contextTxt);
					for (obj in [mainBG, header, songNameText, songNameTxtBG, infoText, infoTextBG, infoTextBG]) {
						obj.visible = true;
						obj.active = true;
					}
					Cursor.cursorMode = Default;
				}
			}
		} else {
			if (contextBoxHovered) {
				contextBoxHovered = false;
				Cursor.cursorMode = Default;
			}
		}
	}
}