function onCreate()
    makeLuaSprite('negro', '', -900, -300)
    makeGraphic('negro', 12000, 12000, '000000')
    setObjectCamera('negro', 'HUD')
    addLuaSprite('negro', true)

    setProperty("gf.visible", false)

    setPropertyFromClass("substates.GameOverSubstate", "characterName", "paranoiaEstailusDead")
    setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'gameoverStartNightmare')
    setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOverNightmare')
    setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEndNightmare')
end

function onUpdate() 
    songPos = getPropertyFromClass('backend.Conductor', 'songPosition') / 1000

    if (songPos >= 106.064 and songPos <= 107.626) then
        if getProperty('camHUD.visible') ~= false then setProperty('camHUD.visible', false) end
        if getProperty('camGame.visible') ~= false then setProperty('camGame.visible', false) end
    elseif (songPos >= 181.241 and songPos <= 182.068) then
        if getProperty('camHUD.visible') ~= true then setProperty('camHUD.visible', true) end
        if getProperty('camGame.visible') ~= false then setProperty('camGame.visible', false) end
    end

    if (songPos > 107.626 and songPos < 181.241) or songPos >= 182.068 then
        if getProperty('camHUD.visible') ~= true then setProperty('camHUD.visible', true) end
        if getProperty('camGame.visible') ~= true then setProperty('camGame.visible', true) end
    end
end

function onGameOverStart()
    if inGameOver then 
        runHaxeCode("FlxG.camera.zoom = 0.5;")
    end
end

function onSongStart()
    doTweenAlpha('bai', 'negro', 0, 1.8, 'cubeinout')
end