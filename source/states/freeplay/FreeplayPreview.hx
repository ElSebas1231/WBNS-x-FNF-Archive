package states.freeplay;

import openfl.media.Sound;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import openfl.media.Sound;
import haxe.io.Path;
import openfl.net.URLRequest;

import states.freeplay.FreeplaySections;

typedef PlayerParams = {
    var ?isInst:Bool;
    var ?loop:Bool;
    var ?startingVolume:Float;
    var ?starting:Float;
    var ?ending:Float;
    var ?suffix:String;
    var ?onLoad:Void->Void;
    var ?onComplete:Void->Void;
};

class FreeplayPreview {
    public var isLooping:Bool = false;
    var params:PlayerParams;

    public function new(params:PlayerParams) {
        this.params = params;
    }

    public function play(path:String) {
        var sound:Sound = Assets.cache.getSound(path);

        if (sound != null) {
            isLooping = false;
            if (FlxG.sound.music != null) FlxG.sound.music.stop();

            FlxG.sound.playMusic(sound, params.startingVolume, params.loop);

            if (params.starting != null) FlxG.sound.music.time = params.starting * 1000;
            if (params.onLoad != null) params.onLoad();

            if (params.loop == true && params.ending != null && params.starting != null) {
                var loopDuration:Float = params.ending - params.starting;
                if (loopDuration > 0) {
                    isLooping = true;
                }
            }

            if (!params.loop && params.onComplete != null) {
                FlxG.sound.music.onComplete = function() {
                    params.onComplete();
                };
            }
        }
    }

    public function update(elapsed:Float) {
        if (FlxG.sound.music != null) {
            if (isLooping) {
                if (FlxG.sound.music.time >= params.ending * 1000) {
                    FlxG.sound.music.time = params.starting * 1000;
                }
            }
        }
    }

    public static function preloadSound(path:String, isInst:Bool, ?onLoaded:Void->Void) {
        //trace('Preload $path');
        if (!Assets.cache.hasSound(path)) {
            var soundPath:String;

            if (FreeplaySections.sectionSelected.contains('dlc')) {
                soundPath = isInst
                    ? 'dlcs/${FreeplaySections.sectionSelected}/songs/${Paths.formatToSongPath(path)}/Inst.${Paths.SOUND_EXT}'
                    : 'dlcs/${FreeplaySections.sectionSelected}/music/$path.${Paths.SOUND_EXT}';
            } else {
                soundPath = isInst
                    ? 'songs:assets/songs/${FreeplaySections.sectionSelected}/${Paths.formatToSongPath(path)}/Inst.${Paths.SOUND_EXT}'
                    : 'assets/shared/music/$path.${Paths.SOUND_EXT}';
            }

            if (Assets.exists(soundPath, AssetType.SOUND)) {
                Assets.loadSound(soundPath, true).onComplete(function(sound:Sound) {
                    if (sound != null) Assets.cache.setSound(path, sound);
                    //trace('Cache tiene: ${Assets.cache.hasSound(path)} | Path: $path');
                    if (onLoaded != null) onLoaded();
                }); 
            } else {
                if (FileSystem.exists(soundPath)) {
                    var sound = new Sound();
                    sound.load(new URLRequest(soundPath));
                    if (sound != null){
                        Assets.cache.setSound(path, sound);
                        //trace('Cache tiene: ${Assets.cache.hasSound(path)} | Path: $path');
                        sound.addEventListener(openfl.events.Event.COMPLETE, function(_) {
                            if (onLoaded != null) onLoaded();
                        });
                    } 
                }
            }
        } else {
            if (onLoaded != null) onLoaded();
        }
    }
}