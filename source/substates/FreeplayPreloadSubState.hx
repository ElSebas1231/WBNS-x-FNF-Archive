package substates;

import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import states.freeplay.FreeplayPreview;

class FreeplayPreloadSubState extends MusicBeatSubstate {
    var songs:Array<{name:String}>;
    var index:Int = 0;
    var loadingBar:FlxBar;
    var progressText:FlxText;
	var bgMusic:FlxSound;

	var wbnsLoading:FlxSprite;

    public function new(songs:Array<{name:String}>) {
        super();
        this.songs = songs;
    }

    override function create() {
        super.create();
        index = 0;

        if (FlxG.sound.music != null) FlxG.sound.music.stop();

        var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		loadingBar = new FlxBar(0, FlxG.height - 26, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 26);
		loadingBar.setRange(0, songs.length);
		add(loadingBar);

		progressText = new FlxText(loadingBar.x, loadingBar.y + 4, FlxG.width, '', 16);
		progressText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER);
		add(progressText);

        wbnsLoading = new FlxSprite(30, 430);
		wbnsLoading.frames = Paths.getSparrowAtlas('ui/menus/loading/loading animation');
		wbnsLoading.animation.addByPrefix('loading', 'loading animation loading anim0', 24, true);
		wbnsLoading.animation.addByPrefix('clear', 'loading animation loading clear0', 24, false);
		wbnsLoading.animation.play('loading', true);
        wbnsLoading.scale.set(0.45, 0.45); 
        wbnsLoading.updateHitbox();
        add(wbnsLoading);

        bgMusic = new FlxSound();
		try {
			var pauseSong:String = Paths.formatToSongPath(ClientPrefs.data.pauseMusic);
			if (pauseSong != null) {
                bgMusic.loadEmbedded(Paths.music(pauseSong), true, true);
                bgMusic.volume = 0;
                bgMusic.play(false, FlxG.random.int(0, Std.int(bgMusic.length / 2)));
                FlxTween.tween(bgMusic, {volume: 1}, 0.55, {ease: FlxEase.smoothStepIn});
            }
		} catch(e:Dynamic) {
            trace('ERROR! $e');
        }

        preloadNext();
    }

    function preloadNext() {
        if (songs.length == 0) {
            progressText.text = "No hay canciones para precargar.";
            FlxTween.tween(loadingBar, {alpha: 0}, 0.6, {ease: FlxEase.smoothStepOut});
            FlxTween.tween(progressText, {alpha: 0}, 0.6, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween) {
                close();
            }});
            return;
        }
    
        if (index < songs.length) {
            var song = songs[index];
            FreeplayPreview.preloadSound(song.name, true, function() {
                index++;
                progressText.text = 'Precargando canciones... (${index}/${songs.length})';
    
                preloadNext();
            });
        } else {
            progressText.text = "¡Listo!";
            wbnsLoading.animation.play('clear', true);

            FlxTween.tween(loadingBar, {alpha: 0}, 0.6, {ease: FlxEase.smoothStepOut});
            FlxTween.tween(progressText, {alpha: 0}, 0.6, {ease: FlxEase.smoothStepOut, onComplete: function(t:FlxTween) {
                close();
            }});
        }

        loadingBar.percent = Math.min((index / songs.length) * 100, 100);
    }

    override function destroy() {
		if (bgMusic != null) bgMusic.destroy();
        if (FlxG.sound.music != null) FlxG.sound.music.play();

		super.destroy();
	}
}