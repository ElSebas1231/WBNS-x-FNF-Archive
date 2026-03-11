import psychlua.LuaUtils;
import hxvlc.flixel.FlxVideoSprite;
import substates.PauseSubState;
import flixel.text.FlxText;
import backend.InputFormatter;

var sprite:FlxSprite;
var video:FlxVideoSprite;
var text:FlxText;
var videoName:String = 'CinematicaItsaRat';

function onCreate() {
    if (!PlayState.seenCutscene && !ClientPrefs.data.lowQuality) {
        video = new FlxVideoSprite();
        video.bitmap.onEndReached.add(() -> { onVideoFinished(); });
        video.camera = LuaUtils.cameraFromString('hud');
        game.add(video);

        createTip('Presiona ' + InputFormatter.getKeyName(ClientPrefs.keyBinds.get('back')[0]) + ' ó ' + InputFormatter.getKeyName(ClientPrefs.keyBinds.get('back')[1]) + ' para saltar la cinemática');
        game.skipCountdown = true;
    }
}

function onCreatePost() {
    if (video != null) {
        game.persistentUpdate = false;
        game.persistentDraw = true;
        game.paused = true;
    
        for (tween in modchartTweens) tween.active = false;
    }
}

function onSongStart() {
    if (video != null) {
        video.load(Paths.video(videoName));
        video.play();
        stopSounds();
    }
}

function onUpdate(elapsed:Float) {
    if (controls.BACK) onVideoFinished();
    stopSounds();
}

function onPause():Void {
    if (video != null) {
        video.pause();

        for (tween in modchartTweens) tween.active = false;

        FlxG.sound.music.pause();
        if (game.vocals != null) game.vocals.pause();
        if (game.opponentVocals != null) game.opponentVocals.pause();

        game.persistentUpdate = false;
        game.persistentDraw = true;
        game.paused = true;
        game.canReset = false;

        game.openSubState(new PauseSubState());
    }
}

function onResume() {
    if (video != null) {
        video.resume();

        for (tween in modchartTweens) tween.active = false;

        FlxG.sound.music.resume();
        if (game.vocals != null) game.vocals.resume();
        if (game.opponentVocals != null) game.opponentVocals.resume();

        game.persistentUpdate = false;
        game.persistentDraw = true;
        game.paused = true;
        game.canReset = false;
    }
}

function onGameOverStart() {
    onVideoFinished();
}

function onDestroy() {
    onVideoFinished();
}

function stopSounds() {
    if (video != null) {
        if (FlxG.sound.music != null){
            if (FlxG.sound.music.playing) FlxG.sound.music.pause();
        } 
    
        if (game.vocals != null) {
            if (game.vocals.playing) game.vocals.pause();
        }
    
        if (game.opponentVocals != null) {
            if (game.opponentVocals.playing) game.opponentVocals.pause();
        }
    }
}

function onVideoFinished() {
    if (text != null) text.destroy();

    if (video != null){
        video.destroy();
        video = null;

        game.persistentUpdate = true;
        game.persistentDraw = true;
        game.paused = false;
        game.canReset = true;

        for (tween in modchartTweens) tween.active = true;

        if (FlxG.sound.music != null){
            FlxG.sound.music.play();

            if (game.vocals != null) game.vocals.play();
            if (game.opponentVocals != null) game.opponentVocals.play();
        }
        game.resyncVocals();
    }
}

function createTip(txt:String = '') {
    text = new FlxText(0, 0, FlxG.width, txt, 32);
    text.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, 'center');
    text.alpha = 0;
    text.screenCenter();
    text.y = 650;
    text.scrollFactor.set();
    text.antialiasing = ClientPrefs.data.antialiasing;
    text.camera = LuaUtils.cameraFromString('hud');
    game.add(text);

    new FlxTimer().start(2.2, function(tmr:FlxTimer) {
        FlxTween.tween(text, {alpha: 1}, 2, {ease: FlxEase.smoothStepIn});
        new FlxTimer().start(2.2, function(tmr:FlxTimer) { FlxTween.tween(text, {alpha: 0}, 4, {ease: FlxEase.smoothStepIn}); });
    });
}