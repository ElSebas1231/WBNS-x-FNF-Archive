import objects.Character;
using StringTools;

var duxoUW:Character;
var locoUW:Character;

function onCreatePost() {
    //x: -380, y: 245
    duxoUW = new Character(game.dad.x - 200, game.dad.y + 145, 'unbeatable-duxo', false);
    duxoUW.x += 200;
    duxoUW.visible = false;
    game.addBehindDad(duxoUW);

    //x: 820, y: 280
    locoUW = new Character(game.dad.x + 1000, game.dad.y + 180, 'unbeatable-loco', false);
    locoUW.visible = false;
    locoUW.flipX = true;
    game.addBehindDad(locoUW);
}

function onEvent(n, v1, v2) {
    if (n == 'Triggers Unbeatable') {
        switch (v1) {
            case '7':
            case '20':
                if (v2 != '1') {
                    for (char in [duxoUW, locoUW]) char.visible = false;
                } else {
                    for (char in [duxoUW, locoUW]) char.visible = true;
                }

            case '25':
                for (char in [duxoUW, locoUW]) char.visible = false;
            case '17':
                if (v2 == '2') for (char in [duxoUW, locoUW]) char.visible = false;

            case '27':
                if (v2 == '1') {
                    duxoUW.visible = true;
                    duxoUW.y += 500;
                    FlxTween.tween(duxoUW, {y: duxoUW.y-500}, 0.8, {ease: FlxEase.backOut});
                }

                if (v2 == '2') {
                    locoUW.visible = true;
                    locoUW.y += 500;
                    FlxTween.tween(locoUW, {y: locoUW.y-500}, 0.8, {ease: FlxEase.backOut});
                }
        }
    }
}

function onUpdate() {
    for (char in [duxoUW, locoUW]) if (char.visible) char.alpha = game.dad.alpha;

    if (Conductor.songPosition / 1000 >= 492.04 && Conductor.songPosition / 1000 < 495) {
        for (note in game.notes) {
            if (note.strumTime >= 492049 && note.strumTime <= 494994) note.noAnimation = true;
        }
    }
}

function onBeatHit() { charBeat(curBeat); }
function onCountdownTick(counter:Int) { charBeat(counter); }

function opponentNoteHit(note:Note) {
    var type = note.noteType;
    var data = note.noteData;

    if (type == 'No Animation' || (curStep >= 4744 && curStep < 4761) || (curStep >= 4791 && curStep < 4806)) {
        duxoUW.holdTimer = 0;
        duxoUW.playAnim(game.singAnimations[data], true);
    }

    if (type == 'GF Sing' || (curStep >= 4761 && curStep < 4776) || (curStep >= 4791 && curStep < 4806)) {
        locoUW.holdTimer = 0;
        if (data == 0) {
            locoUW.playAnim(game.singAnimations[3], true);
        } else if (data == 3) {
            locoUW.playAnim(game.singAnimations[0], true);
        } else locoUW.playAnim(game.singAnimations[data], true);
    }
}

function charBeat(beat:Int) {
    for (char in [duxoUW, locoUW]) {
        if (char != null && beat % char.danceEveryNumBeats == 0 && !char.animation.curAnim.name.startsWith('sing') && !char.stunned)
        char.playAnim('idle');
    }
}