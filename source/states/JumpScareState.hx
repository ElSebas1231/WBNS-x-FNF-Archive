package states;

class JumpScareState extends MusicBeatState {
    var jumpImg:FlxSprite;

    override function create() {
        FlxG.sound.music.stop();

        jumpImg = new FlxSprite().loadGraphic(Paths.image((FlxG.random.bool(25) ? 'duxomr-alt' : 'duxomr')));
        add(jumpImg);

        FlxG.sound.play(Paths.sound('a q meido'), 1, false, null, true, function() {
            Sys.exit(0);
        });

        super.create();
    }
}