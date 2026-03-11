local luigi = 'luigi'
local scaleX = 0.3
local scaleY = 0.3

function onCreatePost()
    if getPropertyFromClass('PlayState', 'curStage') == 'landstage' then
        luigi = 'luigiGB'
        scaleX = 5
        scaleY = 5
    end

    makeLuaSprite('L', 'luigi/'..luigi, 0, (not downscroll and 50 or 580))
    screenCenter('L', 'x')
    scaleObject('L', scaleX, scaleY)
    setObjectCamera('L', 'hud')
    addLuaSprite('L')
    setProperty('botplayTxt.visible', false)

    setProperty('L.x', (getPropertyFromClass('PlayState', 'curStage') == 'landstage' and getProperty('L.x') - 50 or getProperty('L.x') + 100))

    if getPropertyFromClass('PlayState', 'curStage') ~= 'landstage' then
    else
        setProperty('L.antialiasing', false)
    end

    if not botPlay then
        setProperty('L.visible', false)
    else
        setProperty('L.visible', true)
    end
end

local botplaySine = 0
function onUpdate(elapsed)
    botplaySine = botplaySine + 180 * elapsed
    
    if botPlay then
        if not getPropertyFromClass('PlayState', 'isPixelStage') then
            for i = 0, 3 do
                setPropertyFromGroup('playerStrums', i, 'texture', 'Luigi_NOTE_assets')
                setPropertyFromGroup('opponentStrums', i, 'texture', 'Luigi_NOTE_assets')
            end

            for i = 0,getProperty('notes.length')-1 do
                setPropertyFromGroup('notes', i, 'texture', 'Luigi_NOTE_assets')
            end
        end
        setProperty('L.visible', true)
        setProperty('L.angle', ((1 - math.sin((math.pi * botplaySine) / 180)) * 20) - 20)
    else
        setProperty('L.visible', false)
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'texture', 'NOTE_assets')
            setPropertyFromGroup('opponentStrums', i, 'texture', 'NOTE_assets')
        end
        for i = 0,getProperty('notes.length')-1 do
            setPropertyFromGroup('notes', i, 'texture', 'NOTE_assets')
        end
    end
end