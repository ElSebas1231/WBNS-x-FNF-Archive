import objects.Character;
import objects.HealthIcon;
import flixel.util.FlxTimer;
using StringTools;

var natalion:Character;
var tomyexe:Character;
var natIcon:HealthIcon;

function onCreate() {
    // x: 1575| y: 1180
    natalion = new Character(game.dad.x - 400, game.dad.y + 1200, 'natalanexe', false);
    natalion.visible = false;
    natalion.scrollFactor.set(1.1, 1.1);
    game.addBehindDad(natalion);

    // x:775 | y: 1180
    tomyexe = new Character(game.dad.x + 400, game.dad.y, 'tomyexe', false);
    tomyexe.visible = false;
    tomyexe.scrollFactor.set(1.1, 1.1);
    game.addBehindDad(tomyexe);
    
    natIcon = new HealthIcon('icon-natalion', false);
    natIcon.alpha = 0;
    game.uiGroup.add(natIcon);
 
    game.addCharacterToList('mictia', 'dad');
    game.addCharacterToList('mr_D2', 'dad');
}

function onCreatePost() { 
    for (note in game.unspawnNotes) if (note.noteType == 'No Animation') note.multAlpha = 0; 

    FlxTween.tween(game.getLuaObject('dadPlatform'), {y: game.getLuaObject('dadPlatform').y + 150}, 5, {ease: FlxEase.quadInOut, type: 4});
    FlxTween.tween(game.getLuaObject('bfPlatform'), {y: game.getLuaObject('bfPlatform').y - 150}, 5, {ease: FlxEase.quadInOut, startDelay: 1, type: 4});
    FlxTween.tween(game.getLuaObject('gfPlatform'), {y: game.getLuaObject('gfPlatform').y + 150}, 5, {ease: FlxEase.quadInOut, startDelay: 1.5  , type: 4});
    
    FlxTween.tween(game.getLuaObject('roquitas1'), {y: game.getLuaObject('roquitas1').y + 150}, 5, {ease: FlxEase.quadInOut, startDelay: 1.5  , type: 4});
    FlxTween.tween(game.getLuaObject('roquitas2'), {y: game.getLuaObject('roquitas2').y + 150}, 5, {ease: FlxEase.quadInOut, startDelay: 1.5  , type: 4});
}

var natPlat:Bool = false;
var dadPlat:Bool = true;
var cameraTargetting:Bool = true;
function onUpdate() {
    if (natPlat) { natalion.y = game.getLuaObject('extraPlatform').y + 820; }

    if (dadPlat) {
        switch (game.dad.curCharacter) {
            case 'mr_D':
                game.dad.y = game.getLuaObject('dadPlatform').y + 1220;
            case 'mictia':
                game.dad.y = game.getLuaObject('dadPlatform').y + 1380;
            case 'mr_D2':
                game.dad.y = game.getLuaObject('dadPlatform').y + 1490;
        }

        if (game.getLuaObject('explosion') != null) game.getLuaObject('explosion').y = game.dad.y - 250;
    }

    game.boyfriend.y = game.getLuaObject('bfPlatform').y + 1400;
    game.gf.y = game.getLuaObject('gfPlatform').y + 1620;

    if (cameraTargetting) game.moveCameraSection();
}

function onUpdatePost() {
    natIcon.scale.set(game.iconP2.scale.x - 0.2, game.iconP2.scale.y - 0.2);
    natIcon.updateHitbox();

    natIcon.x = game.iconP2.x - 80;
    natIcon.y = game.iconP2.y - 50;
    natIcon.animation.curAnim.curFrame = game.iconP2.animation.curAnim.curFrame;
}

function onEvent(n, v1, v2) {
    if (n == 'FocusCamera') cameraTargetting = false; 

    if (n == 'Trigger Starman') {
        switch (v1) {
            case '1':
                tomyexe.y -= 1200;
                tomyexe.visible = true;
                FlxTween.tween(tomyexe, {y: tomyexe.y+1200}, 0.8, {ease: FlxEase.smoothStepIn});
            case '1-1':
                dadPlat = false;
                game.getLuaObject('explosion').visible = true;
                game.getLuaObject('explosion').playAnim('explosion', true);
                game.triggerEvent('Play Animation', 'caida', 'dad');

                FlxTween.tween(tomyexe, {x: tomyexe.x+500, y: tomyexe.y-1200}, 1.5, {ease: FlxEase.quadInOut, startDelay: 0.5});

                FlxTween.tween(game.dad, {y: game.dad.y+1200}, 0.6, {ease:FlxEase.quadIn, onComplete: function(twn:FlxTween){
                    game.triggerEvent('Change Character', 'dad', 'mictia');
                    game.dad.scrollFactor.set(1.1, 1.1);
                    game.dad.y = 1230;
                    game.dad.alpha = 0;
                    dadPlat = true;
                    game.getLuaObject('explosion').destroy();

                    FlxTween.tween(game.dad, {alpha: 1}, 0.8, {ease: FlxEase.smoothStepOut});
                }});

            case '1-2':
                natPlat = true;
                natalion.visible = true;
                FlxTween.tween(natIcon, {alpha: 1}, 1.5, {ease: FlxEase.smoothStepIn});
				var timer:FlxTimer = new FlxTimer().start(1.5, function(tmr:FlxTimer) {
                    FlxTween.tween(game.getLuaObject('extraPlatform'), {y: game.getLuaObject('extraPlatform').y + 150}, 5, {ease: FlxEase.quadInOut, type: 4});
				});

            case '1-3':
                FlxTween.cancelTweensOf(game.getLuaObject('dadPlatform'));
                game.dad.playAnim('muerte');
                game.dad.specialAnim = true;
                game.dad.animation.finishCallback = function(name:String) {
                    if (name == 'muerte') {
                        dad.visible = false;
                        dadPlat = false;
                    }
                }
            case '1-4':
                natPlat = false;
                FlxTween.cancelTweensOf(natalion);
                FlxTween.cancelTweensOf(game.getLuaObject('extraPlatform'));

                natalion.playAnim('muerte', true);
                natalion.specialAnim = true;
                natalion.animation.finishCallback = function(name:String) {
                    if (name == 'muerte') {
                        natalion.visible = false;
                        FlxTween.tween(game.getLuaObject('extraPlatform'), {y: 1350}, 1.5, {ease: FlxEase.smoothStepOut});
                    }
                }
                FlxTween.tween(natIcon, {alpha: 0}, 1.5, {ease: FlxEase.smoothStepIn});

            case '1-5':
                game.triggerEvent('Change Character', 'dad', 'mr_D2');
                game.dad.scrollFactor.set(1.1, 1.1);
                game.dad.x -= 800;
                game.dad.y = 3200;

                FlxTween.tween(game.dad, {x: game.dad.x+800}, 0.8, {ease: FlxEase.linear});
                FlxTween.tween(game.dad, {y: game.getLuaObject('dadPlatform').y + 1380}, 0.8, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween) {
                    dadPlat = true;
                    FlxTween.tween(game.getLuaObject('dadPlatform'), {y: game.getLuaObject('dadPlatform').y - 150}, 5, {ease: FlxEase.quadInOut, type: 4});
                }});
        }
    }
}

function onMoveCamera(isDad:Bool) { cameraTargetting = true; }

function opponentNoteHit(note:Note) {
    if (note.noteType == 'No Animation') {
        natalion.holdTimer = 0;
        natalion.playAnim(game.singAnimations[note.noteData]);

        tomyexe.holdTimer = 0;
        tomyexe.playAnim(game.singAnimations[note.noteData]);

        if (Conductor.songPosition / 1000 >= 63.750 && Conductor.songPosition / 1000 <= 123.632) {
            if (game.dad.animation.curAnim.name == 'idle' && !mustHitSection) {
                cameraTargetting = false;
                game.camFollow.setPosition(tomyexe.getMidpoint().x + 150, tomyexe.getMidpoint().y - 100);
                game.camFollow.x += tomyexe.cameraPosition[0] + game.opponentCameraOffset[0];
                game.camFollow.y += tomyexe.cameraPosition[1] + game.opponentCameraOffset[1];
            }
        }

        game.opponentStrums.members[note.noteData].playAnim('static');
    } 
}

function goodNoteHitPre(note:Note) {
    if (Conductor.songPosition / 1000 >= 63.750 && Conductor.songPosition / 1000 <= 123.632) {
        if (mustHitSection && tomyexe.animation.curAnim.name.startsWith('sing')) cameraTargetting = true;
    }
}

function onBeatHit() { characterBop(curBeat); }
function onCountdownTick(count:Int) { characterBop(count); }

function characterBop(beat:Int) {
    if (natalion != null && beat % natalion.danceEveryNumBeats == 0 && !natalion.animation.curAnim.name.startsWith('sing') && (!natalion.stunned || !natalion.specialAnim))
        natalion.dance();

    if (tomyexe != null && beat % tomyexe.danceEveryNumBeats == 0 && !tomyexe.animation.curAnim.name.startsWith('sing') && !tomyexe.stunned)
        tomyexe.dance();
}