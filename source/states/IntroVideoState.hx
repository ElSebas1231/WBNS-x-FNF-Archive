package states;

import hxcodec.flixel.FlxVideo;

class IntroVideoState extends MusicBeatState
{
    public static var leftState:Bool = false;
    var sprite:FlxSprite;
    var video:FlxVideo;
    var toTitleTimer:FlxTimer;
    var foundFile:Bool = false;
    var fileName:String;

    override function create() {
        super.create();

        do {
            fileName = Paths.video('intromadness');
            #if sys
            if (FileSystem.exists(fileName)) 
            #else
            if (OpenFlAssets.exists(fileName)) 
            #end
                foundFile = true;
        } while (!foundFile);

        if (foundFile) {
            sprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
            sprite.screenCenter();
            add(sprite);
        
            video = new FlxVideo();
            video.alpha = 0.0;
            video.play(Paths.video('intromadness'), false);
            video.onTextureSetup.add(() -> {
                if (video.bitmapData != null) {
                    sprite.loadGraphic(video.bitmapData);
                } else {
                    if (!TitleState.initialized) {
                        leftState = true;
                        if (video != null) video.dispose();
                        MusicBeatState.switchState(new TitleState());
                    }
                }
            });
            video.onEndReached.add(() -> { 
                FlxTween.tween(sprite, {alpha: 0}, 0.75, {onComplete: function(t:FlxTween) {
                    sprite.destroy();
                    if (!TitleState.initialized) {
                        leftState = true;
                        MusicBeatState.switchState(new TitleState());
                    }
                }});
            });
        }
    }

    var introSkipped:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (foundFile) {
            if (controls.ACCEPT && !introSkipped) {
                video.dispose();
                introSkipped = true;
    
                FlxTween.tween(sprite, {alpha: 0}, 0.45, {onComplete: function(t:FlxTween) {
                    sprite.destroy();
                    leftState = true;
                    MusicBeatState.switchState(new TitleState());
                }});
            }
        }
    }
}