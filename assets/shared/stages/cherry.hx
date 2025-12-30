import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxColor;
import shaders.DropShadow;

var rimBF = new DropShadow();
var rimDAD = new DropShadow();
var rimGF = new DropShadow();

var ambientColor = 0xffdeb887;
var stageHue:Float = -20;
var stageSaturation:Float = -20;
var stageBrightness:Float = -10;
var stageContrast:Float = -20;

function onCreatePost() {
    rimBF.setAdjustColor(stageBrightness, stageHue, stageContrast, stageSaturation);
    rimBF.color = ambientColor;
    rimBF.angle = 90;
    rimBF.distance = 25;
    rimBF.attachedSprite = game.boyfriend;
    game.boyfriend.shader = rimBF;

    rimDAD.setAdjustColor(stageBrightness - 50, stageHue, stageContrast, stageSaturation);
    rimDAD.color = ambientColor;
    rimDAD.angle = 90;
    rimDAD.distance = 10;
    rimDAD.attachedSprite = game.dad;
    game.dad.shader = rimDAD;

    if (game.gf != null) {
        rimGF.setAdjustColor(stageBrightness, stageHue, stageContrast, stageSaturation);
        rimGF.color = ambientColor;
        rimGF.attachedSprite = game.gf;
        rimGF.angle = 90;
        rimGF.distance = 20;
        game.gf.shader = rimGF;
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

    if (game.gf != null) {
        if ((gfColorsMults[0] < 1.0 || gfColorsMults[1] < 1.0 || gfColorsMults[2] < 1.0) || game.gf.color != 16777215) {
            game.gf.shader = null;
        } else {
            game.gf.shader = rimGF;
            rimGF.updateFrameInfo(game.gf.frame);
        }
    }
}