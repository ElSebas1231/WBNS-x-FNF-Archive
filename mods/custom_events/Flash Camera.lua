local alpha = 0
local ease = 'linear'
local color = 'ffffff'
local duration = 0

function onCreate()
    makeLuaSprite('flash', nil, 0, 0)
    makeGraphic('flash', screenWidth * 1.5, screenHeight * 1.5, 'ffffff')
    screenCenter('flash')
    setObjectCamera('flash', 'other')
    setProperty('flash.alpha', 0)
    addLuaSprite('flash', true)
end

function onEvent(n, v1, v2)
    if n == 'Flash Camera' then
        duration = tonumber(v1)
        local opts2 = stringSplit(v2, ",")

        alpha = (tonumber(opts2[1]) ~= '' or opts2[1] == nil) and tonumber(opts2[1]) or 0
        ease = (opts2[2] ~= '' or opts2[2] == nil) and opts2[2] or 'linear'
        color = (opts2[3] ~= '' or opts2[3] == nil) and opts2[3] or 'ffffff'        

        setProperty('flash.color', getColorFromHex(color))
        if duration <= 0 then
            setProperty('flash.alpha', 0)
        else 
            setProperty('flash.alpha', alpha)
            doTweenAlpha('flashAl', 'flash', 0, duration, ease)
        end
    end
end