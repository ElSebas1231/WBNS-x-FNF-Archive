function onCreatePost()
    obtenericoncolor()
    --obtenercolor()
end

function obtenericoncolor()
    iconcolbf = {getProperty('boyfriend.healthColorArray[0]'),getProperty('boyfriend.healthColorArray[1]'),getProperty('boyfriend.healthColorArray[2]')}
    iconcoldad = {getProperty('dad.healthColorArray[0]'),getProperty('dad.healthColorArray[1]'),getProperty('dad.healthColorArray[2]')}
    iconcolgf = {getProperty('gf.healthColorArray[0]'),getProperty('gf.healthColorArray[1]'),getProperty('gf.healthColorArray[2]')}
end

--function obtenercolor()
--    colbf = {getProperty('boyfriend.colorTransform.redOffset'),getProperty('boyfriend.colorTransform.greenOffset'),getProperty('boyfriend.colorTransform.blueOffset')}    
--    colgf = {getProperty('gf.colorTransform.redOffset'),getProperty('gf.colorTransform.greenOffset'),getProperty('gf.colorTransform.blueOffset')}    
--    coldad = {getProperty('dad.colorTransform.redOffset'),getProperty('dad.colorTransform.greenOffset'),getProperty('dad.colorTransform.blueOffset')}    
--    colmultbf = {getProperty('boyfriend.colorTransform.redMultiplier'),getProperty('boyfriend.colorTransform.greenMultiplier'),getProperty('boyfriend.colorTransform.blueMultiplier')}    
--    colmultgf = {getProperty('gf.colorTransform.redMultiplier'),getProperty('gf.colorTransform.greenMultiplier'),getProperty('gf.colorTransform.blueMultiplier')}    
--    colmultdad = {getProperty('dad.colorTransform.redMultiplier'),getProperty('dad.colorTransform.greenMultiplier'),getProperty('dad.colorTransform.blueMultiplier')}
--end


function onEvent(n,v1,v2)
    if n == "Change Character" then
        obtenericoncolor()
    end

    if n == "roval_color" then
        local colortmp = split(v1)
        local spritetmp = split(v2)

        if v1:match(",") == nil then
            colortmp[2] = 'ffffff'
        end
        if v2:match(",") == nil then
            spritetmp[2] = 'todos'
        end


        modocol = (colortmp[1])
        colorcol = (colortmp[2])
        tiempocol = (spritetmp[1])
        spritecol = (spritetmp[2])

        if v1 == '' then
            modocol = 'normal'
            colorcol = 'ffffff'
        end

        if v2 == '' then
            spritecol = 'todos'
            tiempocol = 0.01
        end

        if spritecol == '' then
            spritecol = 'todos'
        end
        if modocol == '' then
            modocol = 'normal'
        end
        if colorcol == '' then
            colorcol = 'ffffff'
        end
        if tiempocol == '' then
            tiempocol = 0.01
        end

        local rojo, verde, azul = hex_rgb(colorcol)

        if spritecol == 'bf' or spritecol == 'boyfriend' or spritecol == 'player' or spritecol == 'jugador' or spritecol == 'novio' then
            esbf = true
            esgf = false
            esdad = false
        elseif spritecol == 'gf' or spritecol == 'girlfriend' or spritecol == 'novia' then
            esbf = false
            esgf = true
            esdad = false
        elseif spritecol == 'dad' or spritecol == 'opponent' or spritecol == 'oponente' or spritecol == 'rival' then
            esbf = false
            esgf = false
            esdad = true
        elseif spritecol == 'todos' then
            esbf = true
            esgf = true
            esdad = true
        end


        --debugPrint('Modo:'..modocol)
        --debugPrint('Para:'..spritecol)
        --debugPrint('Color:'..colorcol)
        --debugPrint('Tiempo:'..tiempocol)
        if modocol == 'normal' then
            rojo = 0
            verde = 0
            azul = 0
            mult = 1

            if esbf == true then
                runHaxeCode([[
                    FlxTween.tween(game.boyfriend.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esgf == true then
                runHaxeCode([[
                    FlxTween.tween(game.gf.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esdad == true then
                runHaxeCode([[
                    FlxTween.tween(game.dad.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
        end

        if modocol == 'full' then
            mult = 0
            if esbf == true then
                runHaxeCode([[
                    FlxTween.tween(game.boyfriend.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esgf == true then
                runHaxeCode([[
                    FlxTween.tween(game.gf.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esdad == true then
                runHaxeCode([[
                    FlxTween.tween(game.dad.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
        end

        if modocol == 'negative' or modocol == 'negativo' then
            mult = -255
            if esbf == true then
                runHaxeCode([[
                    FlxTween.tween(game.boyfriend.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esgf == true then
                runHaxeCode([[
                    FlxTween.tween(game.gf.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esdad == true then
                runHaxeCode([[
                    FlxTween.tween(game.dad.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
        end

        if modocol == 'invert' or modocol == 'invertido' then
            mult = -1
            if esbf == true then
                runHaxeCode([[
                    FlxTween.tween(game.boyfriend.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esgf == true then
                runHaxeCode([[
                    FlxTween.tween(game.gf.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esdad == true then
                runHaxeCode([[
                    FlxTween.tween(game.dad.colorTransform, { redOffset: ]]..rojo..[[, greenOffset: ]]..verde..[[, blueOffset: ]]..azul..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
        end

        if modocol == 'icon' then
            mult = 0
            if esbf == true then
                runHaxeCode([[
                    FlxTween.tween(game.boyfriend.colorTransform, { redOffset: ]]..iconcolbf[1]..[[, greenOffset: ]]..iconcolbf[2]..[[, blueOffset: ]]..iconcolbf[3]..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esgf == true then
                runHaxeCode([[
                    FlxTween.tween(game.gf.colorTransform, { redOffset: ]]..iconcolgf[1]..[[, greenOffset: ]]..iconcolgf[2]..[[, blueOffset: ]]..iconcolgf[3]..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
            if esdad == true then
                runHaxeCode([[
                    FlxTween.tween(game.dad.colorTransform, { redOffset: ]]..iconcoldad[1]..[[, greenOffset: ]]..iconcoldad[2]..[[, blueOffset: ]]..iconcoldad[3]..[[, redMultiplier: ]]..mult..[[, greenMultiplier: ]]..mult..[[, blueMultiplier: ]]..mult..[[ }, ]]..tiempocol..[[);
                ]])
            end
        end

        if modocol == 'inst' then
            if esbf == true then
                setProperty('boyfriend.colorTransform.redOffset', rojo)
                setProperty('boyfriend.colorTransform.greenOffset', verde)
                setProperty('boyfriend.colorTransform.blueOffset', azul)
                setProperty('boyfriend.colorTransform.redMultiplier', 0)
                setProperty('boyfriend.colorTransform.greenMultiplier', 0)
                setProperty('boyfriend.colorTransform.blueMultiplier', 0)
            end
            if esgf == true then
                setProperty('gf.colorTransform.redOffset', rojo)
                setProperty('gf.colorTransform.greenOffset', verde)
                setProperty('gf.colorTransform.blueOffset', azul)
                setProperty('gf.colorTransform.redMultiplier', 0)
                setProperty('gf.colorTransform.greenMultiplier', 0)
                setProperty('gf.colorTransform.blueMultiplier', 0)
            end
            if esdad == true then
                setProperty('dad.colorTransform.redOffset', rojo)
                setProperty('dad.colorTransform.greenOffset', verde)
                setProperty('dad.colorTransform.blueOffset', azul)
                setProperty('dad.colorTransform.redMultiplier', 0)
                setProperty('dad.colorTransform.greenMultiplier', 0)
                setProperty('dad.colorTransform.blueMultiplier', 0)
            end
        end

        if modocol == 'old' then
            if esbf == true then
                doTweenColor('bfcolorr', 'boyfriend', colorcol, tiempocol)
            end
            if esgf == true then
                doTweenColor('gfcolorr', 'gf', colorcol, tiempocol)
            end
            if esdad == true then
                doTweenColor('dadcolorr', 'dad', colorcol, tiempocol)
            end
        end
    end
end

function hex_rgb(hex)
    local rojo = tonumber("0x"..hex:sub(1,2))
    local verde = tonumber("0x"..hex:sub(3,4))
    local azul = tonumber("0x"..hex:sub(5,6))    
    return rojo, verde, azul 
end

function split(s)
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end

