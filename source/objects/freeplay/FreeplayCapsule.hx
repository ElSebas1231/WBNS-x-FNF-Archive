package objects.freeplay;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.display.BlendMode;
import shaders.GaussianBlurShader;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxSpriteGroup;

import backend.Scoring.ScoringRank;

// TODO: Fix positions, add animations, add more stuff

class FreeplayCapsule extends FlxSpriteGroup {
    public var capsule:FlxSprite;
    public var rankIcon:FlxSprite;
    public var songText:CapsuleText;
    public var newText:FlxSprite;
    public var favIcon:FlxSprite;
    public var icon:HealthIcon;

    public var ranking:CapsuleRank;
    public var realScaled:Float = 0.8;
    public var selected(default, set):Bool;
    public var isLocked:Bool = false;
    public var targetPos:FlxPoint = new FlxPoint();
    public var doLerp:Bool = false;
	public var targetY:Float = 0;
    public var onConfirm:Void -> Void;

    public function new(x:Float, y:Float) {
        super(x, y);

        capsule = new FlxSprite(x, y);
        capsule.frames = Paths.getSparrowAtlas('ui/menus/freeplay/songs/capsule/capsule_bf');
        capsule.animation.addByPrefix('unlocked', 'capsule unlocked0', 24, true);
        capsule.animation.addByPrefix('locked', 'capsule locked0', 24, true);
        capsule.antialiasing = ClientPrefs.data.antialiasing;
        add(capsule);

        favIcon = new FlxSprite(x + 300, y + 225);
        favIcon.frames = Paths.getSparrowAtlas('ui/menus/freeplay/songs/capsule/favorite');
        favIcon.animation.addByPrefix('fav', 'favorite corazon anim0', 24, false);
        favIcon.animation.addByPrefix('idle', 'favorite corazon idle0', 24, true);
        favIcon.antialiasing = ClientPrefs.data.antialiasing;
        favIcon.animation.play('idle', true);
        add(favIcon);

        newText = new FlxSprite(x + 480, y + 255);
        newText.frames = Paths.getSparrowAtlas('ui/menus/freeplay/songs/capsule/new');
        newText.animation.addByPrefix('idle', 'NEW notif', 24, true);
        newText.antialiasing = ClientPrefs.data.antialiasing;
        newText.setGraphicSize(Std.int(newText.width * 0.9));
        newText.animation.play('idle', true);
        add(newText);

        ranking = new CapsuleRank(x + 449, y + 281);
        add(ranking);

        songText = new CapsuleText(x + 100, y + 310, 'Random', Std.int(40 * realScaled));
        add(songText);

        icon = new HealthIcon('face', false);
        icon.scale.set(0.65, 0.65);
        icon.x = x - 30;
        icon.y = y + 220;
        add(icon);
    }

    public function init(?x:Float, ?y:Float, capText:String = 'Random', ?charIcon:String = 'face', ?character:String = 'bf'):Void {
        if (x != null) this.x = x;
        if (y != null) this.y = y;

        if(FileSystem.exists(Paths.getPath('images/ui/menus/freeplay/songs/capsule/capsule_${character}.xml'))) {
            capsule.frames = Paths.getSparrowAtlas('ui/menus/freeplay/songs/capsule/capsule_${character}');
        } else {
            capsule.frames = Paths.getSparrowAtlas('ui/menus/freeplay/songs/capsule/capsule_bf');
        }
        capsule.animation.addByPrefix('unlocked', 'capsule unlocked0', 24, true);
        capsule.animation.addByPrefix('locked', 'capsule locked0', 24, true);

        songText.text = capText;
        icon.changeIcon(charIcon);
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);
        if (doLerp) {
            x = MathUtil.coolLerp(x, targetPos.x, 0.3);
            y = MathUtil.coolLerp(y, targetPos.y, 0.4);
        }
    }

    function set_selected(value:Bool):Bool {
        selected = value;
        updateSelected();
        return selected;
    }

    public function checkClip():Void
    {
        var clipSize:Int = 330;
        var clipType:Int = 0;

        if (favIcon.visible) clipType += 1;

        switch (clipType) {
            case 1:
                clipSize = 270;
            case 2:
                clipSize = 280;
        }
        
        songText.clipWidth = clipSize;
    }      

    function updateSelected():Void {
        songText.alpha = this.selected ? 1 : 0.6;
        songText.blurredText.visible = this.selected ? true : false;
        capsule.animation.play(this.isLocked ? "locked" : "unlocked");
        capsule.alpha = this.selected ? 1 : 0.6;
        ranking.alpha = this.selected ? 1 : 0.6;
        favIcon.alpha = this.selected ? 1 : 0.6;
        ranking.color = this.selected ? 0xFFFFFFFF : 0xFFAAAAAA;

        if (songText.tooLong) songText.resetText();

        if (selected && songText.tooLong) songText.initMove();
    }

    public function forcePosition():Void {
        visible = true;
        capsule.alpha = 1;
        updateSelected();
        doLerp = true;

        x = targetPos.x;
        y = targetPos.y;
    }

    public function intendedY(index:Int):Float {
        return FlxMath.lerp((index * 120), y, Math.exp(-FlxG.elapsed * 10.2));
    }

    public function confirm():Void {
        if (songText != null) songText.flickerText();
    }
}

class CapsuleRank extends FlxSprite
{
    public var rank(default, set):Null<ScoringRank> = null;

    function set_rank(val:Null<ScoringRank>):Null<ScoringRank> {
        rank = val;

        if (rank == null || val == null) {
            animation.play('UNKNOW', true, false);
        } else {
            animation.play(rank.getFreeplayRankIconAsset(), true, false);
        }

        return rank = val;
    }

    public function new(x:Float, y:Float) {
        super(x, y);

        this.frames = Paths.getSparrowAtlas('ui/menus/freeplay/songs/capsule/rankbadges');
        this.animation.addByPrefix('PERFECT', 'rank_S0', 24, false);
        this.animation.addByPrefix('PERFECTSICK', 'rank_S0', 24, false);
        this.animation.addByPrefix('EXCELLENT', 'rank_A0', 24, false);
        this.animation.addByPrefix('GOOD', 'rank_B0', 24, false);
        this.animation.addByPrefix('GREAT', 'rank_C0', 24, false);
        this.animation.addByPrefix('LOSS', 'rank_D0', 24, false);
        this.animation.addByPrefix('UNKNOW', 'rank_questionmark0', 24, false);
        this.antialiasing = ClientPrefs.data.antialiasing;

        this.rank = null;

        scale.set(0.9, 0.9);
        updateHitbox();
    }
}