package states;

import hxvlc.flixel.FlxVideoSprite;
import flixel.graphics.FlxGraphic;

class IntroVideoState extends MusicBeatState
{
    public static var leftState:Bool = false;
    var video:FlxVideoSprite;
    var toTitleTimer:FlxTimer;
    var foundFile:Bool = false;
    var fileName:String;

    override function create() {
        super.create();

        var introVideo:String = 'intromadness';

        if (FlxG.random.bool(32)) introVideo = 'intromadness-alt';
        if (FlxG.random.bool(20)) introVideo = 'ajn';

        do {
            fileName = Paths.video(introVideo);
            #if sys
            if (FileSystem.exists(fileName)) 
            #else
            if (OpenFlAssets.exists(fileName)) 
            #end
                foundFile = true;
        } while (!foundFile);

        if (foundFile) {
            video = new FlxVideoSprite();
            video.load(Paths.video(introVideo));
            video.play();

            video.bitmap.onEndReached.add(() -> { 
                FlxTween.tween(video.bitmap, {alpha: 0}, 0.75, {onComplete: function(t:FlxTween) {
                    video.destroy();
                    if (!TitleState.initialized) {
                        leftState = true;
                        MusicBeatState.switchState(new TitleState());
                    }
                }});
            });
            add(video);
        } else {
            leftState = false;
            MusicBeatState.switchState(new TitleState());
        }
    }

    var introSkipped:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (foundFile) {
            if (controls.ACCEPT && !introSkipped) {
                introSkipped = true;
                FlxTween.tween(video, {alpha: 0}, 0.45, {onComplete: function(t:FlxTween) {
                    video.destroy();
                    leftState = true;
                    MusicBeatState.switchState(new TitleState());
                }});
            }
        }
    }
}