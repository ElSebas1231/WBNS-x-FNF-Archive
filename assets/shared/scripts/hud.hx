import objects.Bar;
import objects.HealthIcon;
import flixel.input.keyboard.FlxKey;
import flixel.input.keyboard.FlxKeyboard;
import flixel.math.FlxRect;
import flixel.text.FlxText;

import backend.CoolUtil;
import backend.Scoring;

var newHB:Bar; 
var fakeIconP1:HealthIcon;
var fakeIconP2:HealthIcon;

var ranks:Array<FlxSprite> = ['s', 'a', 'b', 'c', 'd', '?'];
var rankSprite:FlxSprite;
var timeChains:FlxSprite;
var timeChainsBG:FlxSprite;
var mrWebon:FlxSprite;
var scoreText:FlxText;
var missesText:FlxText;
var accuracyText:FlxText;
var songCard:FlxSprite;

var healthLerp:Float = 0;

function onCreatePost() {
    // Normal things goes invisible
    game.healthBar.visible = false;
    game.timeBar.visible = false;
    game.iconP1.visible = false;
    game.iconP2.visible = false;
    game.scoreTxt.visible = false;
    healthLerp = game.health;

    newHB = new Bar(0, FlxG.height * (!ClientPrefs.data.downScroll ? 0.72 : 0.015), 'ui/songs/health bar', function() return healthLerp, 0, 2);
    newHB.leftToRight = false;
    newHB.scrollFactor.set();
    newHB.visible = !ClientPrefs.data.hideHud;
    newHB.alpha = ClientPrefs.data.healthBarAlpha;
    newHB.scale.set(0.6, 0.6);
    newHB.barOffset.x += 210;
    newHB.barOffset.y += 80;
    newHB.barHeight = 45;
    newHB.barWidth = 410;
    newHB.screenCenter(0x01);
    reloadHealthBarColors();
    game.uiGroup.add(newHB);

    rankSprite = new FlxSprite(0, 0);
    rankSprite.frames = Paths.getSparrowAtlas('ui/songs/health bar ranks');
    for (i in 0...ranks.length) rankSprite.animation.addByPrefix('rank'+ranks[i], 'health bar ranks rank ' + ranks[i]);
    rankSprite.x = newHB.x - 158;
    rankSprite.y = newHB.y - 572;
    rankSprite.antialiasing = ClientPrefs.data.antialiasing;
    game.uiGroup.add(rankSprite);

    timeChainsBG = new FlxSprite(0, 0);
    timeChainsBG.frames = Paths.getSparrowAtlas('ui/songs/time bar base');
    timeChainsBG.animation.addByPrefix('idle', 'time bar base idle0', 24, true);
    timeChainsBG.animation.addByPrefix('end', 'time bar base end0', 24, false);
    timeChainsBG.scale.set(0.8, 0.6);
    timeChainsBG.screenCenter(0x11);
    timeChainsBG.x -= 205;
    timeChainsBG.y = newHB.y - 365;
    game.uiGroup.add(timeChainsBG);

    timeChains = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/songs/cadena'));
    timeChains.antialiasing = ClientPrefs.data.antialiasing;
    timeChains.scale.set(0.6, 0.6);
    timeChains.x = newHB.x + 220;
    timeChains.y = timeChainsBG.y + 480;
    game.uiGroup.add(timeChains);
    
    mrWebon = new FlxSprite(0, 0).loadGraphic(Paths.image('ui/songs/mr_webon'));
    mrWebon.antialiasing = ClientPrefs.data.antialiasing;
    mrWebon.scale.set(0.7, 0.7);
    mrWebon.x = timeChains.x + 30;
    mrWebon.y = timeChains.y - 15;
    game.uiGroup.add(mrWebon);

    fakeIconP1 = new HealthIcon(game.boyfriend.healthIcon, true);
    fakeIconP1.x = newHB.x + 670;
    fakeIconP1.y = newHB.y + 30;
    fakeIconP1.visible = !ClientPrefs.data.hideHud;
    fakeIconP1.alpha = ClientPrefs.data.healthBarAlpha;
    game.uiGroup.add(fakeIconP1);

    fakeIconP2 = new HealthIcon(game.dad.healthIcon, false);
    fakeIconP2.x = newHB.x + 22;
    fakeIconP2.y = newHB.y + 30;
    fakeIconP2.visible = !ClientPrefs.data.hideHud;
    fakeIconP2.alpha = ClientPrefs.data.healthBarAlpha;
    game.uiGroup.add(fakeIconP2);

    scoreText = new FlxText(0, 0, FlxG.width, "", 20);
    scoreText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 20, FlxColor.WHITE, 'center', game.scoreTxt.borderStyle, FlxColor.BLACK);
    scoreText.scrollFactor.set();
    scoreText.borderSize = 2;
    scoreText.x = newHB.x - 400;
    scoreText.y = newHB.y + 35;
    scoreText.antialiasing = ClientPrefs.data.antialiasing;
    game.uiGroup.add(scoreText);

    missesText = new FlxText(0, 0, FlxG.width, "", 20);
    missesText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 20, FlxColor.WHITE, 'center', game.scoreTxt.borderStyle, FlxColor.BLACK);
    missesText.scrollFactor.set();
    missesText.borderSize = 2;
    missesText.x = scoreText.x + 360;
    missesText.y = scoreText.y;
    missesText.antialiasing = ClientPrefs.data.antialiasing;
    game.uiGroup.add(missesText);

    accuracyText = new FlxText(0, 0, FlxG.width, "", 20);
    accuracyText.setFormat(Paths.font("PhantomMuff Full Letters 1.1.5.ttf"), 20, FlxColor.WHITE, 'center', game.scoreTxt.borderStyle, FlxColor.BLACK);
    accuracyText.scrollFactor.set();
    accuracyText.borderSize = 2;
    accuracyText.x = newHB.x - 220;
    accuracyText.y = newHB.y + 55;
    accuracyText.antialiasing = ClientPrefs.data.antialiasing;
    game.uiGroup.add(accuracyText);

    for (i in 0...game.strumLineNotes.length) {
        if (i >= 0 && i <= 3) {
            game.strumLineNotes.members[i].y -= 5;
        } else {
            game.strumLineNotes.members[i].y -= 5;
        }
    }

    songCard = new FlxSprite().loadGraphic(Paths.image('ui/songs/cards/card_'+game.songName.toLowerCase()));
    songCard.antialiasing = ClientPrefs.data.antialiasing;
    songCard.scale.set(0.65, 0.65);
    songCard.updateHitbox();
    songCard.screenCenter();
    songCard.alpha = 0;
    songCard.cameras = [game.camOther];
    game.add(songCard);

    updateScore(false);

    game.botplayTxt.y = newHB.y - 60;
    game.botplayTxt.font = 'PhantomMuff 1.5';

    game.timeTxt.y = timeChainsBG.y + 535;
    game.timeTxt.font = 'PhantomMuff 1.5';
    game.timeTxt.size = 20;
    game.timeTxt.antialiasing = ClientPrefs.data.antialiasing;
    updateRank();
}

function onSongStart() {
    if (songCard.visible != true) songCard.visible = true;
    FlxTween.tween(songCard, {alpha: 1}, (Conductor.crochet / 1000) * 2.8, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) {
        FlxTween.tween(songCard, {alpha: 0}, (Conductor.crochet / 1000) * 2.5, {ease: FlxEase.cubeOut, startDelay: 1.2});
    }});
}

function onUpdatePost(elapsed:Float) {
    // alpha thingie
    newHB.alpha = rankSprite.alpha = timeChainsBG.alpha = timeChains.alpha = mrWebon.alpha = game.healthBar.alpha;
    fakeIconP1.alpha = game.iconP1.alpha;
    fakeIconP2.alpha = game.iconP2.alpha;
    scoreText.alpha = missesText.alpha = accuracyText.alpha = game.scoreTxt.alpha;

    if (newHB.bounds.max != null && game.health > newHB.bounds.max) game.health = newHB.bounds.max;
    healthLerp = FlxMath.lerp(healthLerp, game.health, 0.15);

    updateTimeChains(elapsed);

    fakeIconP1.animation.curAnim.curFrame = (newHB.percent < 20) ? 1 : 0;
    fakeIconP2.animation.curAnim.curFrame = (newHB.percent > 80) ? 1 : 0;

    if (Conductor.songPosition >= FlxG.sound.music.length - 1000) {
        FlxG.sound.music.onComplete = null;
        if (FlxG.sound.music != null) FlxG.sound.music.kill();
        if (game.vocals != null) game.vocals.kill();
        if (game.opponentVocals != null) game.opponentVocals.kill();

        timeChains.visible = false;
        mrWebon.visible = false;

        timeChainsBG.animation.play('end', true);
        timeChainsBG.animation.finishCallback = function(name:String) {
            if (name == 'end')  {
                timeChainsBG.visible = false;
                new FlxTimer().start(1.2, function(tmr:FlxTimer) {
                    game.endSong();
                });
            }
        }
    }
}

function updateTimeChains(elapsed:Float) {
    var musicTime:Float = FlxG.sound.music.time;
    var musicLength:Float = FlxG.sound.music.length;
    var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset);
    var songPercent = (curTime / musicLength);
    
    // DON'T EVEN ASK ME HOW THIS FUCKING WORK, BC I DON'T KNOW EITHER 
    if (timeChains.width - (-20 + songPercent * 480) >= 0) {
        timeChains.x = newHB.x + 180 + (songPercent * 330);
        mrWebon.x = timeChains.x + 35;
        
        timeChains.clipRect = new FlxRect(0, 0, timeChains.width - (-20 + songPercent * 480), timeChains.height);
    }
}

function updateScore() {
    scoreText.text = 'Score: ' + game.songScore;
    missesText.text = 'Misses: ' + game.songMisses;
}

function goodNoteHit() {
    if (!game.cpuControlled) {
        updateScore();
        updateRank();
    }
}
function noteMiss() {
    if (!game.cpuControlled) {
        updateScore();
        updateRank();
    }
}

var rankScaleTween:FlxTween;
var rank:String = '';
var previousRank:String = '';

function updateRank() {
    var rating = Math.min(1, Math.max(0, game.totalNotesHit / game.totalPlayed));
    if(Math.isNaN(rating)) rating = 0;
    accuracyText.text = 'Accuracy: ' + CoolUtil.floorDecimal(rating * 100, 2) + '%';
    rank = Scoring.calculateRankFromData(game.songScore, rating);

    if (rank == 'PERFECT') {
        previousRank = 'PERFECT';
        rankSprite.animation.play('ranks', true, false);
    } else if (rank == 'EXCELLENT') {
        previousRank = 'EXCELLENT';
        rankSprite.animation.play('ranka', true, false);
    } else if (rank == 'GREAT') {
        previousRank = 'GREAT';
        rankSprite.animation.play('rankb', true, false);
    } else if (rank == 'GOOD') {
        previousRank = 'GOOD';
        rankSprite.animation.play('rankc', true, false);
    } else if (rank == 'SHIT') {
        previousRank = 'SHIT';
        rankSprite.animation.play('rankd', true, false);
    } else if (rank == null) {
        rankSprite.animation.play('rank?', true, false);
    }
}

function reloadHealthBarColors() {
    newHB.setColors(FlxColor.fromRGB(game.dad.healthColorArray[0], game.dad.healthColorArray[1], game.dad.healthColorArray[2]),
    FlxColor.fromRGB(game.boyfriend.healthColorArray[0], game.boyfriend.healthColorArray[1], game.boyfriend.healthColorArray[2]));
}