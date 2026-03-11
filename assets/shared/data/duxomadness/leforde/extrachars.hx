import objects.Character;
using StringTools;

var dangf:Character;
var fugalgf:Character;

function onCreatePost() {
    dangf = new Character(game.gf.x - 210, game.dad.y - 70, 'dangf', true);
    game.addBehindGF(dangf);

    fugalgf = new Character(game.dad.x + 800, game.dad.y + 100, 'fugalgf', true);
    game.addBehindGF(fugalgf);
}

function onUpdatePost() {
    if (game.gf.animation.curAnim.name == 'sad') {
        dangf.playAnim('void', true);
        dangf.specialAnim = true;

        fugalgf.playAnim('risa', true);
        fugalgf.specialAnim = true;
    }
}

function onEvent(n, v1, v2) {
    if (n == 'Play Animation') {
        if (v2 == 'dan') {
            dangf.playAnim(v1, true);
            dangf.specialAnim = true;
        }
        
        if (v2 == 'fugal') {
            fugalgf.playAnim(v1, true);
            fugalgf.specialAnim = true;
        }
    }
}

function onBeatHit() { charBeat(curBeat); }
function onCountdownTick(counter:Int) { charBeat(counter); }

function charBeat(beat:Int) {
    for (char in [dangf, fugalgf]) {
        if (char != null && beat % char.danceEveryNumBeats == 0 && !char.animation.curAnim.name.startsWith('sing') && !char.stunned) 
            char.dance();
    }
}