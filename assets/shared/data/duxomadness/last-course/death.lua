local state = -1

function onCreatePost()
    setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'natalanChicken-dead')
    setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'turmoil_death1')
    setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOverNew')
    setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEndNew')
end

function onUpdate()
    if inGameOver and state ~= -1 then
        if state == 0 then
            if getProperty('boyfriend.animation.curAnim.name') == 'deathLoop' then
                runTimer('goombaGameOver', 2)
                runHaxeCode("FlxG.sound.music.stop();")
                state = 1
            end
        end
    end
end

function onGameOverStart() state = 0 end

function onTimerCompleted(tag)
    if tag == 'goombaGameOver' then
        setProperty('boyfriend.visible', true)
        doTweenAlpha('bfAlpha', 'boyfriend', 1, 3, 'cubeOut')
        playMusic('gameOverNew', 0)
        soundFadeIn(nil, 2, 0, 1)
    end
end