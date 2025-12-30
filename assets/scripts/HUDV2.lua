local scoreRating = {'SS+', 'S+', 'S', 'A+', 'A', 'B', 'C', 'D', 'E'}
local scoreAccuracy = {100, 90, 80, 70, 65, 60, 50, 40}
local Rating = ''
local hudColor = 'F42626'
local healthBar = 'healthBarNEW'

function onCreatePost()
    runHaxeCode([[
        game.healthBar.bg.loadGraphic(Paths.image(']]..healthBar..[['));
        game.healthBar.bg.antialiasing = false;
        game.healthBar.bg.offset.set(45,5);
        return;
    ]])
 
    makeLuaText('scoreMM', nil, 1000, 400, getProperty('healthBar.bg.y') + 36)
    setTextSize('scoreMM', 15)
    setTextBorder('scoreMM', 1.25, '000000')
    setObjectCamera('scoreMM', 'hud')
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
    if botPlay then
        if getPropertyFromClass('states.PlayState', 'curStage') ~= 'landstage' then
            setTextColor('timeTxt', '25cd49')
            setTextColor('scoreMM', '25cd49')
            runHaxeCode([[
                game.healthBar.bg.loadGraphic(Paths.image('healthBarNEWluigi'));
                game.healthBar.bg.antialiasing = false;
                game.healthBar.bg.offset.set(45,5);
                return;
            ]])
            if luaTextExists('song') then
                setTextBorder('song', 3, '25cd49')
                setTextBorder('composer', 3, '25cd49')
            end
            if luaTextExists('kornelbut') then
                setTextBorder('kornelbut', 2, '25cd49')
            end
            setProperty('timeBar.leftBar.color', getColorFromHex('25cd49'))
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
            setTextBorder('song', 3, getColorFromHex(hudColor))
            setTextBorder('composer', 3, getColorFromHex(hudColor))
        end

        if luaTextExists('kornelbut') then
            setTextBorder('kornelbut', 2, getColorFromHex(hudColor))
        end
        setProperty('timeBar.leftBar.color', getColorFromHex(hudColor))
    end
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