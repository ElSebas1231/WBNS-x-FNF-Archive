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
    if getPropertyFromClass('backend.Conductor', 'songPosition') / 1000 >= 106.064 and getPropertyFromClass('backend.Conductor', 'songPosition') / 1000 <= 107.626 then
        setProperty('camHUD.visible', false)
        setProperty('camGame.visible', false)
    end

    if getPropertyFromClass('backend.Conductor', 'songPosition') / 1000 > 107.626 then
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