--Creado por Roval, usalo pero deja créditos :D
activado = false
function onEvent(n,v1,v2)
    if n == "roval_flash" or n == 'Change Character' then --Al usar el evento
        local flash1 = split(v1) --Divide el value1
        local flash2 = split(v2) --Divide el value2
        local hola = v2:match('^[^,]*,[^,]*$') ~= nil --Verifica si hay 2 comas en value2
        if v1 == '' then --Si no escribes nada en v1
            flash1[1] = 1.75
            flash1[2] = 0.57
        elseif v1:match(",") == nil then --Si escribes solo el tiempo en v1
            flash1[2] = 0.57
        end
        pusocol = true
        if v2 == '' then --Si no escribes nada en v2
            pusocol = false
            flash2[1] = 'normal'
            flash2[2] = "linear"
            flash2[3] = 'ffffff'
        elseif v2:match(",") == nil then --Si escribes solo el modo en v2
            if v2 == 'normal' or v2 == 'alpha' or v2 == 'color' then
                pusocol = false
                flash2[2] = "linear"
                flash2[3] = 'ffffff'
            else
                flash2[3] = v2
                flash2[2] = "linear"
                flash2[1] = "normal"
            end
        elseif hola then --Si escribes solo el modo y el easing en v2
            pusocol = false
            flash2[3] = 'ffffff'
        end

        --Acá se atribuyen los valores de v1 y v2 a las variables que se usan luego
        tiempoflash = (flash1[1])
        opaflash = (flash1[2])

        modflash = (flash2[1])
        easeflash = (flash2[2])
        colflash = (flash2[3])

        if activado == false then --Revisa si se creó o no el sprite, si ya se creó entonces no hará estas acciones
            activado = true
            makeLuaSprite('flash', '', 0, 0); 
            makeGraphic('flash', 1285*2.3, 725*2.3, 'ffffff');
            screenCenter('flash');
            setScrollFactor('flash', 0, 0);
            setProperty('flash.alpha',0.0001)
            setProperty('flash.color',getColorFromHex(colflash))
            --setBlendMode('flash', 'add')
            addLuaSprite('flash', true);
        end

        if modflash == 'normal' then --Modo flash: El modo predeterminado de uso, un flash corriente
            if pusocol == true then
                setProperty('flash.color', getColorFromHex(colflash))
            end
            setProperty('flash.alpha',opaflash)
            doTweenAlpha('flashopa','flash',0,tiempoflash,easeflash)
        end
        if modflash == 'color' then --Modo color: Tween color al que vos quieras
            alphaflash = getProperty('flash.alpha')
            colortween = true
            doTweenColor('flashcol','flash',colflash,tiempoflash,easeflash)
        end
        if modflash == 'alpha' then --Modo alpha: Ajusta la opacidad del sprite a lo que desees
            doTweenAlpha('flashopa','flash',opaflash,tiempoflash,easeflash)
        end
    end
    function onTweenCompleted(n)
        if n == 'flashcol' then
            colortween = false
            setProperty('flash.alpha', alphaflash) --Se hace por el bug que hay en psych engine con los tweens
        end 
        if n == 'flashopa' then
            if getProperty('flash.alpha') == 0 then --Revisa si el flash está invisible para eliminarlo (Optimización)
                activado = false
                removeLuaSprite('flash',true)
            end
        end 
    end
end

function onUpdate()
    if colortween == true then
        setProperty('flash.alpha', alphaflash)--Se hace por el bug que hay en psych engine con los tweens
    end
end


function split(s) --Función con la que se dividen los valores del evento
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end