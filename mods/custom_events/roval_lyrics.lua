function onEvent(n,v1,v2)
    if n == "roval_lyrics" then
        local TextConfig = split(v2)
        modeText = TextConfig[1]
        sizeText = tonumber(TextConfig[2])
        xText = tonumber(TextConfig[3])
        yText = tonumber(TextConfig[4])
        colorText = TextConfig[5]
        fontText = TextConfig[6]
        alphaText = TextConfig[6]
        intro = TextConfig[7]
        fin = TextConfig[8]
        if v2 == '' then
            modeText = 'hud'
            sizeText = 50
            xText = 0
            yText = 0
            colorText = 'ffffff'
            fontText = 'vcr.ttf'
            alphaText = 1
            intro = 1
            fin = 1
        end
        if v2:match(",") == nil then
            sizeText = 50
            xText = 0
            yText = 0
            colorText = 'ffffff'
            fontText = 'vcr.ttf'
            alphaText = 1
            intro = 1
            fin = 1
        end

        if v1 == '' then
            runTimer('fintextob',0.01)
        else
            setProperty('textob.alpha',1)
            makeLuaText('textob', '', 1560, xText, yText)
            setTextFont('textob', fontText)
            setTextColor('textob', colorText)
            setTextSize('textob', sizeText+23)
            setProperty('textob.antialiasing', getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing'))
            setTextAlignment('textob', 'center')
            setTextString('textob',  '' .. v1)
            setProperty('textob.scale.x',1.06)
            setProperty('textob.scale.y',0.93)
            addLuaText('textob')

            runTimer('mueve',0.02)

            if modeText == 'hud' then
                setObjectCamera("textob", 'hud');

                --ChatGPT ayudó carreando esta parte XD (Mucha matemática para mí :,p)
                local maxVelocity = 2 -- Velocidad máxima en píxeles por segundo
                local numSteps = 3 -- Número de pasos en el movimiento curvilíneo
            
                if math.random(0,1) == 0 then
                    local newY = yText + math.random(-3, -9)
                    local distance = math.abs(newY - yText)
                    local duration = distance / maxVelocity
                    local stepDuration = duration / numSteps
            
                    for i = 1, numSteps do
                        local stepY = yText + (newY - yText) * i / numSteps
                        stepY = stepY + math.random(-2, 2) -- Agregar variación aleatoria
            
                        local tag = 'textoby' .. i
                        doTweenY(tag, 'textob', stepY, stepDuration, 'linear')
                    end
                else
                    local newY = yText + math.random(3, 9)
                    local distance = math.abs(newY - yText)
                    local duration = distance / maxVelocity
                    local stepDuration = duration / numSteps
            
                    for i = 1, numSteps do
                        local stepY = yText + (newY - yText) * i / numSteps
                        stepY = stepY + math.random(-2, 2) -- Agregar variación aleatoria
            
                        local tag = 'textoby' .. (numSteps - i + 1)
                        doTweenY(tag, 'textob', stepY, stepDuration, 'linear')
                    end
                end
            
                if math.random(2,3) == 2 then
                    local newX = xText + math.random(-3, -9)
                    local distance = math.abs(newX - xText)
                    local duration = distance / maxVelocity
                    local stepDuration = duration / numSteps
            
                    for i = 1, numSteps do
                        local stepX = xText + (newX - xText) * i / numSteps
                        stepX = stepX + math.random(-2, 2) -- Agregar variación aleatoria
            
                        local tag = 'textobx' .. i
                        doTweenX(tag, 'textob', stepX, stepDuration, 'linear')
                    end
                else
                    local newX = xText + math.random(3, 9)
                    local distance = math.abs(newX - xText)
                    local duration = distance / maxVelocity
                    local stepDuration = duration / numSteps
            
                    for i = 1, numSteps do
                        local stepX = xText + (newX - xText) * i / numSteps
                        stepX = stepX + math.random(-2, 2) -- Agregar variación aleatoria
            
                        local tag = 'textobx' .. (numSteps - i + 1)
                        doTweenX(tag, 'textob', stepX, stepDuration, 'linear')
                    end
                end
            else

                runHaxeCode(
                    [[
                        game.modchartTexts.get('textob').cameras = [game.camGame];
                        game.modchartTexts.get('textob').scrollFactor.set(1,1);
                        return;
                    ]]
                )

                if modeText == 'bf' then
                    --falta hacer
                elseif modeText == 'dad' then
                    --falta hacer
                elseif modeText == 'gf' then
                    --falta hacer
                elseif modeText == 'bg' then
                    --falta hacer
                    runHaxeCode(
                        [[
                            game.insert(game.members.indexOf(game.dadGroup)+5,game.modchartTexts.get('textob'));
                            return;
                        ]]
                    )
                end
            end
        end
    end
end

function onTweenCompleted(nombre,var) --ChatGPT ayudó carreando esta parte XD (Mucha matemática para mí :,p)
    local maxVelocity = 2 -- Velocidad máxima en píxeles por segundo
    local numSteps = 3 -- Número de pasos en el movimiento curvilíneo

    if nombre == 'textoby1' then
        local newY = yText + math.random(-3, -9)
        local distance = math.abs(newY - yText)
        local duration = distance / maxVelocity
        local stepDuration = duration / numSteps

        for i = 1, numSteps do
            local stepY = yText + (newY - yText) * i / numSteps
            stepY = stepY + math.random(-2, 2) -- Agregar variación aleatoria

            local tag = 'textoby' .. i
            doTweenY(tag, 'textob', stepY, stepDuration, 'linear')
        end
    elseif nombre == 'textoby0' then
        local newY = yText + math.random(3, 9)
        local distance = math.abs(newY - yText)
        local duration = distance / maxVelocity
        local stepDuration = duration / numSteps

        for i = 1, numSteps do
            local stepY = yText + (newY - yText) * i / numSteps
            stepY = stepY + math.random(-2, 2) -- Agregar variación aleatoria

            local tag = 'textoby' .. (numSteps - i + 1)
            doTweenY(tag, 'textob', stepY, stepDuration, 'linear')
        end
    end

    if nombre == 'textobx3' then
        local newX = xText + math.random(-3, -9)
        local distance = math.abs(newX - xText)
        local duration = distance / maxVelocity
        local stepDuration = duration / numSteps

        for i = 1, numSteps do
            local stepX = xText + (newX - xText) * i / numSteps
            stepX = stepX + math.random(-2, 2) -- Agregar variación aleatoria

            local tag = 'textobx' .. i
            doTweenX(tag, 'textob', stepX, stepDuration, 'linear')
        end
    elseif nombre == 'textobx2' then
        local newX = xText + math.random(3, 9)
        local distance = math.abs(newX - xText)
        local duration = distance / maxVelocity
        local stepDuration = duration / numSteps

        for i = 1, numSteps do
            local stepX = xText + (newX - xText) * i / numSteps
            stepX = stepX + math.random(-2, 2) -- Agregar variación aleatoria

            local tag = 'textobx' .. (numSteps - i + 1)
            doTweenX(tag, 'textob', stepX, stepDuration, 'linear')
        end
    end
end


--function onEvent(n,v1,v2)
--    if n == "roval" then
--        if v1 == 'canta' then --Activar para cambiar el texto de karaoke
--            if v2 == '' then
--                textito = '' --Si no escribes nada borras el texto
--            else
--                textito = v2
--            end
--            setTextString('texto',  '' .. textito)
--        end
--        if v1 == 'cantab' then --Activar para cambiar el texto de karaoke - Segundo texto
--            if v2 == '' then
--                textitob = '' --Si no escribes nada borras el texto
--            else
--                textitob = v2
--            end
--            doTweenX('textitobaa', 'textob', getMidpointX('dad')-460, 0.001)
--            doTweenY('textitob', 'textob', getMidpointY('dad')-100, 0.001)
--            runTimer('muevetextob', 0.001)
--            doTweenAlpha('textob', 'textob', 0.7, 0.15)
--            setTextString('textob',  '' .. textitob)
--            runTimer('fintextob', 0.3)
--end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'fintextob' then
        doTweenAlpha('textob', 'textob', 0, 0.2, 'quadOut')
    end
    if tag == 'muevetextob' then
        doTweenX('textitoaba', 'textob', getMidpointX('dad')-450, 0.7, 'quadIn')
        doTweenY('textitoab', 'textob', getMidpointY('dad')-40, 0.7, 'quadOut')
    end
    if tag == 'mueve' then
        runTimer('mueve2',0.01)
        setProperty('textob.scale.x',1.03)
        setProperty('textob.scale.y',0.97)
    end
    if tag == 'mueve2' then
        setProperty('textob.scale.x',1)
        setProperty('textob.scale.y',1)
    end
end

function split(s)
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end