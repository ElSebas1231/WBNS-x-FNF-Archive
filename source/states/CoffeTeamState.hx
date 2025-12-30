package states;

class CoffeTeamState extends MusicBeatState
{
    public static var leftState:Bool = false;

    var coffeSprite:FlxSprite;
    var blackTop:FlxSprite;

    var toTitleTimer:FlxTimer;

    override function create()
    {
        super.create();

        coffeSprite = new FlxSprite();
        coffeSprite.frames = Paths.getSparrowAtlas('ui/menus/intro/coffe_team_logo');
        coffeSprite.animation.addByPrefix('intro', 'logo intro', 24, false);
        coffeSprite.animation.addByPrefix('idle', 'idle logo', 24, true);
        coffeSprite.animation.play('intro');
        coffeSprite.x = 360;
        coffeSprite.y = -36;

        FlxG.sound.play(Paths.sound('tea_sound'));

        coffeSprite.animation.finishCallback = function(name:String) {
            if (name == 'intro') {
                coffeSprite.animation.play('idle');
                coffeSprite.y = 46;
            }
        }

        coffeSprite.scale.set(0.65, 0.65);
        coffeSprite.updateHitbox();
        coffeSprite.antialiasing = ClientPrefs.data.antialiasing;
        add(coffeSprite);
        
        blackTop = new FlxSprite().makeGraphic(1280, 720, 0xFF000000);
        blackTop.alpha = 0;
        add(blackTop);

        toTitleTimer = new FlxTimer().start(2.3, function(t:FlxTimer) {
            FlxTween.tween(blackTop, {alpha: 1}, 0.75, {onComplete: function(t:FlxTween) {
                new FlxTimer().start(0.35, function(t:FlxTimer) {
                    leftState = true;
                    MusicBeatState.switchState(new TitleState());
                });
            }});
        });
    }

    var introSkipped:Bool = false;
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.ACCEPT && !introSkipped) {
            toTitleTimer.cancel();
            introSkipped = true;
            
            if (FlxG.sound.music != null) FlxG.sound.music.fadeOut(0.15, 0);

            FlxTween.tween(blackTop, {alpha: 1}, 0.45, {onComplete: function(t:FlxTween) {
                leftState = true;
                MusicBeatState.switchState(new TitleState());
            }});
        }
    }
}