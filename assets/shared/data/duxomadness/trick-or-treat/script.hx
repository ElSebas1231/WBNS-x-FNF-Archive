import objects.Character;
using StringTools;

var duxo:Character;
var pump:Character;

function onCreatePost() {
    duxo = new Character(game.gf.x - 930, game.gf.y + 140, 'spookyDuxo', false);
    game.dadGroup.add(duxo);

    pump = new Character(game.boyfriend.x + 350, game.boyfriend.y - 255, 'spookyPump', true);
    game.boyfriendGroup.add(pump);

    setVar('pump', pump);
    setVar('duxo', duxo);

    for (note in game.unspawnNotes) if (note.noteType == 'C3jo Note') note.noAnimation = true;
}

function opponentNoteHit(note:Note) {
    if (note.noteType == 'No Animation') {
        game.defaultCamZoom = 1.3;
        game.dad.alpha = duxo.alpha = 1;

        duxo.holdTimer = 0;
        duxo.playAnim(game.singAnimations[note.noteData], true);

        game.camFollow.setPosition(duxo.getMidpoint().x, duxo.getMidpoint().y);
        game.camFollow.x += duxo.cameraPosition[0] + game.opponentCameraOffset[0];
        game.camFollow.y += duxo.cameraPosition[1] + game.opponentCameraOffset[1];

        game.iconP2.changeIcon('duxo_icon');
        game.healthBar.setColors(FlxColor.fromString('#71498b'),
        FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
    } 

    if (note.noteType == 'GF Sing') {
        game.defaultCamZoom = 1.25;
        game.camFollow.setPosition(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
        game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
        game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1];

        game.iconP2.changeIcon('locochon_icon');
        game.healthBar.setColors(FlxColor.fromString('#594e60'),
        FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
        game.dad.alpha = duxo.alpha = 0.65;
    }

    if (note.noteType == 'C3jo Note') {
        game.gf.holdTimer = 0;
        game.defaultCamZoom = 1.45;
        game.gf.playAnim(game.singAnimations[note.noteData]+'-C3jo', true);
        game.camFollow.setPosition(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
        game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0];
        game.camFollow.y += (game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1]) + 50;

        game.iconP2.changeIcon('c3jo_icon');
        game.healthBar.setColors(FlxColor.fromString('#ef763a'),
        FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
        game.dad.alpha = duxo.alpha = 0.65;
    }

    if (note.noteType == '') {
        game.defaultCamZoom = 1.1;
        game.iconP2.changeIcon(game.dad.healthIcon);
        game.healthBar.setColors(FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]),
        FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));

        game.dad.alpha = duxo.alpha = 1;
    }
}

function onUpdatePost(elapsed:Float) {
    game.iconP1.animation.curAnim.curFrame = (game.healthBar.percent < 20) ? 1 : 0;
    game.iconP2.animation.curAnim.curFrame = (game.healthBar.percent > 80) ? 1 : 0;

    if (game.iconP2.char == 'c3jo_icon') {
        if (game.iconP2.animation.curAnim.curFrame == 1) {
            game.healthBar.setColors(FlxColor.fromString('#efc4af'),
            FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
        } else {
            game.healthBar.setColors(FlxColor.fromString('#ef763a'),
            FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
        }
    }
}

function goodNoteHitPre(note:Note) {
    game.defaultCamZoom = 1;
    pump.holdTimer = 0;
    pump.playAnim(game.singAnimations[note.noteData], true);
    pump.specialAnim = true;

    if (!duxo.animation.curAnim.name.startsWith('sing')) duxo.alpha = 1;
    if (!game.dad.animation.curAnim.name.startsWith('sing')) game.dad.alpha = 1;
}

function noteMiss(note:Note) {
    pump.holdTimer = 0;
    pump.playAnim(game.singAnimations[note.noteData]+"miss", true);
    pump.specialAnim = true;
}

function onBeatHit() { characterBop(curBeat); }
function onCountdownTick(count:Int) { characterBop(count); }

function characterBop(beat:Int) {
    if (duxo != null && beat % duxo.danceEveryNumBeats == 0 && !duxo.animation.curAnim.name.startsWith('sing') && !duxo.stunned)
        duxo.dance();

    if (pump != null && beat % pump.danceEveryNumBeats == 0 && !pump.animation.curAnim.name.startsWith('sing') && !pump.stunned)
        pump.dance();
}