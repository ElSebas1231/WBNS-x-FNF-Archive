import flixel.addons.display.FlxBackdrop;
import shaders.DropShadow;
import shaders.ColorSwap;

var mistY:Float = 400;
var dirMist:String = 'misc/c3jo/main/';

function onCreate() {
    var mist0:FlxBackdrop = new FlxBackdrop(Paths.image(dirMist+'mistMid'), 0x01);
    mist0.velocity.set(172, 0);
    mist0.blend = 0;
    mist0.color = 0xFF5c5c5c;
    mist0.y = mistY;
    game.add(mist0);
}

var rimBF = new DropShadow();
var rimDAD = new DropShadow();
var rimGF = new DropShadow();

var stageHue:Float = -20;
var stageSaturation:Float = -20;
var stageBrightness:Float = -10;
var stageContrast:Float = -20;

function onCreatePost() {
    rimBF.setAdjustColor(stageBrightness, stageHue, stageContrast, stageSaturation);
    rimBF.color = 0xFF3CDDEF;
    rimBF.angle = 90;
    rimBF.distance = 25;
    rimBF.attachedSprite = game.boyfriend;
    game.boyfriend.shader = rimBF;

    rimDAD.setAdjustColor(stageBrightness, stageHue, stageContrast, stageSaturation);
    rimDAD.color = 0xFF3CDDEF;
    rimDAD.angle = 90;
    rimDAD.distance = 20;
    rimDAD.attachedSprite = game.dad;
    game.dad.shader = rimDAD;

    rimGF.setAdjustColor(stageBrightness, stageHue, stageContrast, stageSaturation);
    rimGF.color = 0xFF3CDDEF;
    rimGF.attachedSprite = game.gf;
    rimGF.angle = 90;
    rimGF.distance = 20;
    game.gf.shader = rimGF;

    if (ClientPrefs.data.flashing) {
        var coolors = new ColorSwap();
        game.getLuaObject('bg3').shader = coolors.shader;
        FlxTween.tween(coolors, {hue: 1}, (Conductor.crochet / 1000) * 20, {type: 2});
    }
}

function onUpdatePost(elapsed:Float) {
    var bfColorsMults = [
        game.boyfriend.colorTransform.redMultiplier, game.boyfriend.colorTransform.greenMultiplier, game.boyfriend.colorTransform.blueMultiplier
    ];

    var dadColorsMults = [
        game.dad.colorTransform.redMultiplier, game.dad.colorTransform.greenMultiplier, game.dad.colorTransform.blueMultiplier
    ];

    var gfColorsMults = [
        game.gf.colorTransform.redMultiplier, game.gf.colorTransform.greenMultiplier, game.gf.colorTransform.blueMultiplier
    ];

    if ((bfColorsMults[0] < 1.0 || bfColorsMults[1] < 1.0 || bfColorsMults[2] < 1.0) || game.boyfriend.color != 16777215) {
        game.boyfriend.shader = null;
    } else {
        game.boyfriend.shader = rimBF;
        rimBF.updateFrameInfo(game.boyfriend.frame);
    }

    if ((dadColorsMults[0] < 1.0 || dadColorsMults[1] < 1.0 || dadColorsMults[2] < 1.0) || game.dad.color != 16777215) {
        game.dad.shader = null;
    } else {
        game.dad.shader = rimDAD;
        rimDAD.updateFrameInfo(game.dad.frame);
    }

    if ((gfColorsMults[0] < 1.0 || gfColorsMults[1] < 1.0 || gfColorsMults[2] < 1.0) || game.gf.color != 16777215) {
        game.gf.shader = null;
    } else {
        game.gf.shader = rimGF;
        rimGF.updateFrameInfo(game.gf.frame);
    }
}