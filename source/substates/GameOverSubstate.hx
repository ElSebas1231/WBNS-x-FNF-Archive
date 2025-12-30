package substates;

import backend.WeekData;

import objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;

import states.StoryMenuState;
import states.freeplay.FreeplayState;
import states.freeplay.FreeplaySections;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;
	var stageSuffix:String = "";
	var gameOverMusic:FlxSound;
	
	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';
	public static var hasIntro:Bool = false;

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';

		var _song = PlayState.SONG;
		if(_song != null)
		{
			if(_song.gameOverChar != null && _song.gameOverChar.trim().length > 0) characterName = _song.gameOverChar;
			if(_song.gameOverSound != null && _song.gameOverSound.trim().length > 0) deathSoundName = _song.gameOverSound;
			if(_song.gameOverLoop != null && _song.gameOverLoop.trim().length > 0) loopSoundName = _song.gameOverLoop;
			if(_song.gameOverEnd != null && _song.gameOverEnd.trim().length > 0) endSoundName = _song.gameOverEnd;
		}
	}

	var charX:Float = 0;
	var charY:Float = 0;
	override function create()
	{
		instance = this;

		Conductor.songPosition = 0;

		boyfriend = new Character(PlayState.instance.boyfriend.getScreenPosition().x, PlayState.instance.boyfriend.getScreenPosition().y, characterName, true);
		boyfriend.x += boyfriend.positionArray[0] - PlayState.instance.boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1] - PlayState.instance.boyfriend.positionArray[1];
		add(boyfriend);

		var deathSound = Paths.sound(deathSoundName);
		trace('Sound = null?: ${deathSound == null}');
		if (deathSound != null) {
			FlxG.sound.play(deathSound, 1, false, null, true, function() {
				playingDeathSound = false;
			});
		}

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0], boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1]);
		FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2)));
		add(camFollow);
		
		PlayState.instance.setOnScripts('inGameOver', true);
		PlayState.instance.callOnScripts('onGameOverStart', []);

		super.create();
	}

	public var startedDeath:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnScripts('onUpdate', [elapsed]);

		if (controls.ACCEPT) endBullshit(false);

		if (controls.BACK) {
			#if desktop DiscordClient.resetClientID(); #end
			endBullshit(true);
		}
		
		if (boyfriend.animation.curAnim != null) {
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
				boyfriend.playAnim('deathLoop');

			if(boyfriend.animation.curAnim.name == 'firstDeath') {
				if(boyfriend.animation.curAnim.curFrame >= 12 && !moveCamera) {
					FlxG.camera.follow(camFollow, LOCKON, 0.6);
					moveCamera = true;
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound) {
					startedDeath = true;
					coolStartDeath();
				}
			}
		}

		PlayState.instance.callOnScripts('onUpdatePost', [elapsed]);
	}

	function coolStartDeath(?volume:Float = 1):Void	{
		if (hasIntro) {
			FlxG.sound.play(Paths.music('$loopSoundName-intro'), volume, false, null, true,() -> {
				FlxG.sound.playMusic(Paths.music(loopSoundName), volume, true);
				FlxG.sound.music.looped = true;
			});
		} else {
			FlxG.sound.playMusic(Paths.music(loopSoundName), volume, true);
			FlxG.sound.music.looped = true;
		}
	}

	var isEnding:Bool = false;
	function endBullshit(backToMenu:Bool = false):Void
	{
		if (!backToMenu){
			if (!isEnding){
				isEnding = true;
				boyfriend.playAnim('deathConfirm', true);
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.sound(endSoundName));
				new FlxTimer().start(0.7, function(tmr:FlxTimer) {
					FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
						MusicBeatState.resetState();
					});
				});
				PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
			}
		} else {
			if (!isEnding) {
					isEnding = true;
					boyfriend.playAnim('deathConfirm');
					FlxG.sound.music.stop();	
					FlxG.sound.play(Paths.sound(endSoundName));
					PlayState.instance.callOnScripts('onGameOverConfirm', [false]);
					new FlxTimer().start(0.7, function(tmr:FlxTimer) {
					FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
						PlayState.deathCounter = 0;
						PlayState.seenCutscene = false;
		
						var stickerSet = 'stickers-set-wbns';
						var stickerPack = 'all';
			
						if (FreeplaySections.sectionSelected.contains('duxo')) {
							stickerSet = 'stickers-set-dm';
			
							stickerPack = switch (PlayState.SONG.song.toLowerCase()) {
								case "its a rat": "itsarat";
								case "last course": "lastCourse";
								case "nightmare": "nightmare";
								case "sdlg": "sdlg";
								case "trick or treat": "trickOrTreat";
								case "tryhard slaughter": "tryhard";
								case "unwebonable v2": "unwebonable";
								case "all wbns": "duxoMadness";
								default: "all";
							};
						}

						if (!ClientPrefs.data.noStickers) {
							if (stickerSet != null) StickerSubState.STICKER_SET = stickerSet else StickerSubState.STICKER_SET = 'stickers-set-wbns';
							if (stickerPack != null) StickerSubState.STICKER_PACK = stickerPack else StickerSubState.STICKER_PACK = 'all';
							
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
		
						FlxG.sound.play(Paths.sound('cancelMenu'));
						FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
						FlxG.sound.music.fadeIn(2, 0, 1);
					});
				});
			}
		}
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}
