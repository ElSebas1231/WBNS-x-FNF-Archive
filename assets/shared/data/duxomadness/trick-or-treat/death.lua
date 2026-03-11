local dead = false

function onCreate()
    defaultZoom = getProperty('defaultCamZoom')
    addHaxeLibrary('Character', 'objects')

    runHaxeCode([[
        var skidGM:Character;
        var pumpGM:Character;

        skidGM = new Character(game.boyfriend.x - 40, game.boyfriend.y + 40, 'skid-dead', true);
        game.add(skidGM);

        pumpGM = new Character(game.boyfriend.x + 250, game.boyfriend.y - 20, 'pump-dead', true);
        game.add(pumpGM);

        setVar('skidGM', skidGM);
        setVar('pumpGM', pumpGM);
    ]])

    makeAnimatedLuaSprite('retrySprite', 'spooky/retrySpooky', 450, 350)
    addAnimationByPrefix('retrySprite', 'firstDeath', 'firstDeath', 24, false)
    addAnimationByPrefix('retrySprite', 'deathLoop', 'deathLoop', 24, false)
    addAnimationByPrefix('retrySprite', 'deathConfirm', 'deathConfirm', 24, false)
    setObjectOrder('retrySprite', getObjectOrder('boyfriendGroup'))
    addLuaSprite('retrySprite', true)

    for i, v in ipairs({'retrySprite', 'skidGM', 'pumpGM'}) do 
        setProperty(v .. '.visible', false)
        playAnim(v, 'firstDeath', true) 
    end
end

function onGameOver()
    if not dead then
        cameraSetTarget('boyfriend')
        setProperty('defaultCamZoom', defaultZoom)
        openCustomSubstate('death')
        
        stopSounds()
        freezedPos = getPropertyFromClass('backend.Conductor', 'songPosition')
        dead = true
    end
    return Function_Stop
end


function onPause()
    if dead then
        return Function_Stop
    end
end

function onCustomSubstateCreate(tag)
    if tag == 'death' then
        runHaxeCode([[
            game.defaultCamZoom = 1;
            game.camFollow.setPosition(game.gf.getMidpoint().x, game.gf.getMidpoint().y);
            game.camFollow.x += game.gf.cameraPosition[0] + game.girlfriendCameraOffset[0] - 50;
            game.camFollow.y += game.gf.cameraPosition[1] + game.girlfriendCameraOffset[1] + 200; 
        ]])

        playSound('fnf_loss_sfx', 1)
        for i, v in ipairs({'bgNoDoor', 'bgDoor', 'boyfriend', 'pump', 'duxo', 'camHUD', 'dad', 'gf'}) do setProperty(v .. '.visible', false) end
        for i, v in ipairs({'retrySprite', 'skidGM', 'pumpGM'}) do 
            setProperty(v .. '.visible', true)
            playAnim(v, 'firstDeath', true) 
        end
    end
end

local canSelect = false
function onCustomSubstateUpdate(tag,elapsed)
    if tag == 'death' then
        setProperty('cameraSpeed', 1.5)

        if getProperty('skidGM.animation.curAnim.name') == 'firstDeath' then
            if getProperty('skidGM.animation.curAnim.finished') then
                canSelect = true
                playAnim('skidGM', 'deathLoop', true)
                playMusic('gameOver', 1, true)
            end
        end

        if canSelect then
            if keyJustPressed('back') then
                runTimer('back', 2.5)

                for i, v in ipairs({'retrySprite', 'skidGM', 'pumpGM'}) do playAnim(v, 'deathConfirm', true) end
                
                stopSounds()
                canSelect = false
            end

            if keyJustPressed('accept') then
                playSound('gameOverEnd', 1)
                for i, v in ipairs({'retrySprite', 'skidGM', 'pumpGM'}) do playAnim(v, 'deathConfirm', true) end
                runTimer('accept', 2.5)

                stopSounds()
                canSelect = false
            end
        end

        setProperty('persistentUpdate', true)
        setPropertyFromClass('backend.Conductor', 'songPosition', freezedPos)
    end
end

function stopSounds()
    runHaxeCode([[
        if (game.vocals != null) { game.vocals.stop(); }
        if (game.opponentVocals != null) { game.opponentVocals.stop(); }

        FlxG.sound.music.stop();
    ]])
end

function onTimerCompleted(t)
    if t == 'accept' then
        closeCustomSubstate()
        setPropertyFromClass('states.PlayState', 'deathCounter', getPropertyFromClass('states.PlayState', 'deathCounter') + 1)
        restartSong()
    end

    if t == 'back' then
        exitSong()
    end
end