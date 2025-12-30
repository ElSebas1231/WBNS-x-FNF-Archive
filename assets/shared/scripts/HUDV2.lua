local scoreRating = {'SS+', 'S+', 'S', 'A+', 'A', 'B', 'C', 'D', 'E'}
local scoreAccuracy = {100, 90, 80, 70, 65, 60, 50, 40}
local Rating = ''
local hudColor = 'F42626'
local healthBar = 'healthBarNEW'

local rgbColors = {
    {'df4ee6', '000000', 'ff7aff'},
    {'008aff', '000000', 'd7ffff'},
    {'009400', '000000', 'dcff6c'},
    {'920202', '000000', 'ff3737'},
}

local rbgBotColors = {
    {'075800', '000000', '13e200'},
    {'075800', '000000', '13e200'},
    {'075800', '000000', '13e200'},
    {'075800', '000000', '13e200'},
}

local loadedHealthBar = false

function onCreatePost()
    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'useRGBShader', false)
        setPropertyFromGroup('playerStrums', i, 'useRGBShader', false)
    end

    if not loadedHealthBar then
        loadGraphic('healthBar.bg', healthBar)
        setProperty('healthBar.bg.antialiasing', false)
        setProperty('healthBar.bg.offset.x', 45)
        setProperty('healthBar.bg.offset.y', 5)
        loadedHealthBar = true
    end
 
    makeLuaText('scoreMM', nil, 1000, 400, getProperty('healthBar.bg.y') + 36)
    setTextSize('scoreMM', 15)
    setTextBorder('scoreMM', 1.25, '000000')
    setObjectCamera('scoreMM', 'hud')
    setObjectOrder('scoreMM', getObjectOrder('uiGroup') + 1)
    screenCenter('scoreMM', 'x')
    setTextColor('scoreMM', hudColor)
    setTextFont("scoreMM", "mario2.ttf"); 
    addLuaText('scoreMM')

    setProperty('scoreTxt.visible', false)
    setProperty('timeBar.leftBar.color', getColorFromHex(hudColor))
    setTextColor('timeTxt', hudColor);
    setTextSize('timeTxt', 20)
    setProperty('timeTxt.y', getProperty('timeBar.y') - 2.6)
    setTextFont("timeTxt", "mario2.ttf"); 

    setTextString('scoreMM', 'Score: '..score..'      Misses: '..misses..'      Rating: '..ratingName)
end

function onUpdate()
    setProperty('scoreMM.alpha', getProperty('scoreTxt.alpha'))
    if botPlay then
        if getPropertyFromClass('states.PlayState', 'curStage') ~= 'landstage' then
            setTextColor('timeTxt', '25cd49')
            setTextColor('scoreMM', '25cd49')

            if loadedHealthBar then
                loadedHealthBar = false
                loadGraphic('healthBar.bg', 'healthBarNEWluigi')
                setProperty('healthBar.bg.antialiasing', false)
                setProperty('healthBar.bg.offset.x', 45)
                setProperty('healthBar.bg.offset.y', 5)
                loadedHealthBar = true
            end

            if luaTextExists('song') then
                setTextBorder('song', 3, '25cd49')
                setTextBorder('composer', 3, '25cd49')
            end
            if luaTextExists('kornelbut') then
                setTextBorder('kornelbut', 2, '25cd49')
            end
            setProperty('timeBar.leftBar.color', getColorFromHex('25cd49'))

            for i = 0, getProperty('notes.length')-1 do
                noteData = getPropertyFromGroup('notes', i, 'noteData')
                setPropertyFromGroup('notes', i, 'rgbShader.enabled', false)
                setPropertyFromGroup('notes', i, 'noteCoverData.useRGBShader', true)
                setPropertyFromGroup('notes', i, 'noteCoverData.r', getColorFromHex(rbgBotColors[noteData + 1][1]))
                setPropertyFromGroup('notes', i, 'noteCoverData.g', getColorFromHex(rbgBotColors[noteData + 1][2]))
                setPropertyFromGroup('notes', i, 'noteCoverData.b', getColorFromHex(rbgBotColors[noteData + 1][3]))

                setPropertyFromGroup('notes', i, 'noteSplashData.useRGBShader', true)
                setPropertyFromGroup('notes', i, 'noteSplashData.r', getColorFromHex(rbgBotColors[noteData + 1][1]))
                setPropertyFromGroup('notes', i, 'noteSplashData.g', getColorFromHex(rbgBotColors[noteData + 1][2]))
                setPropertyFromGroup('notes', i, 'noteSplashData.b', getColorFromHex(rbgBotColors[noteData + 1][3]))
            end
        end
    else
        setTextColor('timeTxt', hudColor)
        setTextColor('scoreMM', hudColor)
        runHaxeCode([[
            game.healthBar.bg.loadGraphic(Paths.image(']]..healthBar..[['));
            game.healthBar.bg.antialiasing = false;
            game.healthBar.bg.offset.set(45,5);
            return;
        ]])

        if luaTextExists('song') then
            setTextBorder('song', 3, hudColor)
            setTextBorder('composer', 3, hudColor)
        end

        if luaTextExists('kornelbut') then
            setTextBorder('kornelbut', 2, hudColor)
        end

        setProperty('timeBar.leftBar.color', getColorFromHex(hudColor))

        for i = 0, getProperty('notes.length')-1 do
            noteData = getPropertyFromGroup('notes', i, 'noteData')
            setPropertyFromGroup('notes', i, 'rgbShader.enabled', false)
            setPropertyFromGroup('notes', i, 'noteCoverData.useRGBShader', true)
            setPropertyFromGroup('notes', i, 'noteCoverData.r', getColorFromHex(rgbColors[noteData + 1][1]))
            setPropertyFromGroup('notes', i, 'noteCoverData.g', getColorFromHex(rgbColors[noteData + 1][2]))
            setPropertyFromGroup('notes', i, 'noteCoverData.b', getColorFromHex(rgbColors[noteData + 1][3]))

            setPropertyFromGroup('notes', i, 'noteSplashData.useRGBShader', true)
            setPropertyFromGroup('notes', i, 'noteSplashData.r', getColorFromHex(rgbColors[noteData + 1][1]))
            setPropertyFromGroup('notes', i, 'noteSplashData.g', getColorFromHex(rgbColors[noteData + 1][2]))
            setPropertyFromGroup('notes', i, 'noteSplashData.b', getColorFromHex(rgbColors[noteData + 1][3]))
        end
    end
end

function onBeatHit()
    setProperty('iconP1.scale.x', 1.1)
    setProperty('iconP1.scale.y', 1.1)

    setProperty('iconP2.scale.x', 1.1)
    setProperty('iconP2.scale.y', 1.1)

    doTweenX('p1ScaleX', 'iconP1.scale', 1, 0.5 * (1 / (curBpm / 60)), 'cubeOut')
    doTweenY('p1ScaleY', 'iconP1.scale', 1, 0.5 * (1 / (curBpm / 60)), 'cubeOut')

    doTweenX('p2ScaleX', 'iconP2.scale', 1, 0.5 * (1 / (curBpm / 60)), 'cubeOut')
    doTweenY('p2ScaleY', 'iconP2.scale', 1, 0.5 * (1 / (curBpm / 60)), 'cubeOut')
end

function onUpdateScore()
    accuracy = round(rating * 100, 2)

    if getPropertyFromClass('backend.ClientPrefs', 'data.scoreZoom') then
        scaleObject('scoreMM', 1.075, 1.075)
        doTweenX('scale1', 'scoreMM.scale', 1, 0.2, 'smoothStepIn')
        doTweenY('scale2', 'scoreMM.scale', 1, 0.2, 'smoothStepIn')
    end

    if accuracy == scoreAccuracy[1] then
        Rating = scoreRating[1]
    elseif accuracy >= scoreAccuracy[2] then
        Rating = scoreRating[2]
    elseif accuracy >= scoreAccuracy[3] then
        Rating = scoreRating[3]
    elseif accuracy >= scoreAccuracy[4] then
        Rating = scoreRating[4]
    elseif accuracy >= scoreAccuracy[5] then
        Rating = scoreRating[5]
    elseif accuracy >= scoreAccuracy[6] then
        Rating = scoreRating[6]
    elseif accuracy >= scoreAccuracy[7] then
        Rating = scoreRating[7]
    elseif accuracy >= scoreAccuracy[8] then
        Rating = scoreRating[8]
    elseif accuracy <= scoreAccuracy[8] then
        Rating = scoreRating[9]
    end
    
    setTextString('scoreMM', 'Score: '..score..'      Misses: '..misses..'      Rating: '..Rating.. ' ('..accuracy..'%)')
end

function round(x, n) --https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end