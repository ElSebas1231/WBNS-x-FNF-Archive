import objects.Character;
using StringTools;

var natalon:Character;
var c370:Character;
var a2002:Character;

function onCreatePost() {
    natalon = new Character(game.gf.x - 800, game.gf.y + 450, 'natalon', false);
    natalon.alpha = 0;
    game.add(natalon);

    a2002 = new Character(game.gf.x - 1350, game.gf.y + 550, '2002', false);
    a2002.alpha = 0;
    game.addBehindBF(a2002);

    c370 = new Character(game.gf.x - 1800, game.gf.y + 200, 'C370', false);
    c370.alpha = 0;
    game.add(c370);
}

function onBeatHit() { charBeat(curBeat); }
function onCountdownTick(counter:Int) { charBeat(counter); }

function onEvent(n, v1, v2) {
    if (n == 'Triggers All Stars') {
        if (v1 == '3' && v2 == '3') {
            for (char in [natalon, c370, a2002]) {
                FlxTween.tween(char, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepIn});
            }
        }

        if (v1 == '4' && v2 == '0') {
            for (char in [natalon, c370, a2002]) {
                char.visible = char.active = false;
            }
        }
    }
}

function opponentNoteHit(note:Note) {
    var type = note.noteType;
    var data = note.noteData;

    if (type != 'GF Sing' || type == '') {
        if (type == 'c370' || type == 'c370 hide') {
            c370.holdTimer = 0;
            c370.playAnim(game.singAnimations[data], true);
        }

        if (type == 'natalon' || type == 'natalon hide') {
            natalon.holdTimer = 0;
            natalon.playAnim(game.singAnimations[data], true);
        }

        if (type == 'c370 hide' || type == 'natalon hide') game.opponentStrums.members[data].playAnim('static'); else game.opponentStrums.members[data].playAnim('confirm');
    } else {
        a2002.holdTimer = 0;
        a2002.playAnim(game.singAnimations[data], true);
    }
}

function charBeat(beat:Int) {
    for (char in [natalon, c370, a2002]) {
        if (char != null && beat % char.danceEveryNumBeats == 0 && !char.animation.curAnim.name.startsWith('sing') && !char.stunned)
        char.playAnim('idle');
    }
}