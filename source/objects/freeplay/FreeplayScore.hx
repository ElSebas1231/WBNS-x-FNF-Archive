package objects.freeplay;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class FreeplayScore extends FlxTypedSpriteGroup<ScoreNum>
{
    public var scoreShit(default, set):Int = 0;

    function set_scoreShit(val):Int
    {
        if (group == null || group.members == null || group.members.length == 0) return val;

        var loopNum:Int = group.members.length - 1;
        var dumbNumb = Std.parseInt(Std.string(val));
        var prevNum:ScoreNum;

        while (dumbNumb > 0) {
            group.members[loopNum].digit = dumbNumb % 10;

            dumbNumb = Math.floor(dumbNumb / 10);
            loopNum--;
        }

        while (loopNum > 0) {
            group.members[loopNum].digit = 0;
            loopNum--;
        }

        return val;
    }

    public function new(x:Float, y:Float, digitCount:Int, scoreShit:Int = 100) {
        super(x, y);

        for (i in 0...digitCount) {
            add(new ScoreNum(x + (42 * i), y, 0));
        }

        this.scoreShit = scoreShit;
    }

    public function updateScore(scoreNew:Int) {
        scoreShit = scoreNew;
    }
}

class ScoreNum extends FlxSprite
{
    public var digit(default, set):Int = 0;

    function set_digit(val):Int
    {

        if (animation.curAnim != null && animation.curAnim.name != numToString[val]) {
            animation.play(numToString[val], true, false, 0);
            updateHitbox();

            switch (val)
            {
            case 1:
                //offset.x -= 15;
            case 5:
                // set offsets
                // offset.x += 0;
                // offset.y += 10;

            case 7:
                // offset.y += 6;
            case 4:
                // offset.y += 5;
            case 9:
                // offset.y += 5;
            default:
                centerOffsets(false);
            }
        }

        return val;
    }

    public var baseY:Float = 0;
    public var baseX:Float = 0;

    var numToString:Array<String> = ["ZERO", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE"];

    public function new(x:Float, y:Float, ?initDigit:Int = 0)
    {
        super(x, y);

        baseY = y;
        baseX = x;

        frames = Paths.getSparrowAtlas('ui/menus/freeplay/songs/score/DIGITAL NUMBERS');

        for (i in 0...10) {
            var stringNum:String = numToString[i];
            animation.addByPrefix(stringNum, 'DIGITAL NUMBERS $stringNum DIGITAL0', 24, false);
        }

        this.digit = initDigit;
        animation.play(numToString[digit], true);
        setGraphicSize(Std.int(width * 0.95));
        updateHitbox();
    }
}
