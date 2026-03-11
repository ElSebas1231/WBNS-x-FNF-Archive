package states;

import hxvlc.flixel.FlxVideoSprite;
import flixel.graphics.FlxGraphic;

class VideoPlayerState extends MusicBeatState {
    var videoToPlay:String;
    var fileName:String;
    var foundFile:Bool = false;
    var canSkip:Bool = false;

    var video:FlxVideoSprite;
    var text:FlxText;

    public function new(video:String) {
        videoToPlay = video;
        super();
    }

    override function create() {
        super.create();

        do {
            fileName = Paths.video(videoToPlay);
            #if sys
            if (FileSystem.exists(fileName)) 
            #else
            if (OpenFlAssets.exists(fileName)) 
            #end
                foundFile = true;
        } while (!foundFile);

        if (foundFile) {
            video = new FlxVideoSprite();
            video.load(Paths.video(videoToPlay));
            video.play();

            video.bitmap.onEndReached.add(() -> { 
                FlxTween.tween(video.bitmap, {alpha: 0}, 0.75, {onComplete: function(t:FlxTween) {
                    video.destroy();
                    MusicBeatState.switchState(new TitleState());
                }});
            });
            add(video);

            text = new FlxText(0, 0, FlxG.width, 'Presiona ${ClientPrefs.keyBinds.get('back')[0]} ó ${ClientPrefs.keyBinds.get('back')[1]} para saltar', 32);
            text.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 32, FlxColor.WHITE, 'center');
            text.alpha = 0;
            text.screenCenter();
            text.y = 650;
            text.scrollFactor.set();
            text.antialiasing = ClientPrefs.data.antialiasing;
            add(text);

            new FlxTimer().start(2.2, function(tmr:FlxTimer) {
                FlxTween.tween(text, {alpha: 1}, 2, {ease: FlxEase.smoothStepIn, onComplete: function(twn:FlxTween) {
                    canSkip = true;
                }});
                new FlxTimer().start(2.2, function(tmr:FlxTimer) {FlxTween.tween(text, {alpha: 0}, 4, {ease: FlxEase.smoothStepIn});});
            });
        } else MusicBeatState.switchState(new VideoPlayerState(videoToPlay));
    }

    var videoSkipped:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (foundFile && canSkip) {
            if (controls.ACCEPT && !videoSkipped) {
                videoSkipped = true;
                FlxTween.tween(video, {alpha: 0}, 0.45, {onComplete: function(t:FlxTween) {
                    video.destroy();
                    MusicBeatState.switchState(new TitleState());
                }});
            }
        }
    }
}