local on = false

function onUpdate(elapsed)
    if on then
        setProperty('camHUD.zoom', lerp(getProperty('camHUD.zoom'), 0.72, elapsed))
        setProperty('camGame.zoom', lerp(getProperty('camGame.zoom'), getProperty('defaultCamZoom') - 0.20, elapsed))
        setProperty('camZooming', false)
    end
end

function onChange()
    if on then on = false else on = true end
end

function lerp(a, b, ratio)
    return a + ratio * (b - a)
end

function onEvent(name,value1)
    if name == "CamaraHudZoom" then
        if value1 == "on" then
        doTweenY('frontcrowd99', 'frontcrowd', -400, 1, 'circOut')
    end     
        if value1 == "" then
        doTweenY('frontcrowd99', 'frontcrowd',  425, 3, 'circOut')
         end
       end
    if name == 'CamaraHudZoom' then onChange() end
end
