--ATENCIÓN: REQUIERES LA IMAGEN "luz" DENTRO DE "mods/images" o "nombredemodfolder/images" PARA QUE FUNCIONE
--Creado por Roval, usalo pero deja créditos :D
activado2 = false
function onEvent(n,v1,v2)
    if n == "roval_luz" then --Al usar el evento
        local luz1 = split(v1) --Divide el value1
        local luz2 = split(v2) --Divide el value2
        local hola2 = v2:match('^[^,]*,[^,]*$') ~= nil --Verifica si hay 2 comas en value2
        if v1 == '' then --Si no escribes nada en v1
            luz1[1] = 0.8
            luz1[2] = 0.65
        elseif v1:match(",") == nil then --Si escribes solo el tiempo en v1
            luz1[2] = 0.65
        end
        pusocol = true
        if v2 == '' then --Si no escribes nada en v2
            pusocol = false
            luz2[1] = 'normal'
            luz2[2] = "linear"
            luz2[3] = 'ffffff'
        elseif v2:match(",") == nil then --Si escribes solo el modo en v2
            if v2 == 'normal' or v2 == 'alpha' or v2 == 'color' then
                pusocol = false
                luz2[2] = "linear"
                luz2[3] = 'ffffff'
            else
                luz2[3] = v2
                luz2[2] = "linear"
                luz2[1] = "normal"
            end
        elseif hola2 then --Si escribes solo el modo y el easing en v2
            pusocol = false
            luz2[3] = 'ffffff'
        end

        --Acá se atribuyen los valores de v1 y v2 a las variables que se usan luego
        tiempoluz = (luz1[1])
        opaluz = (luz1[2])

        modluz = (luz2[1])
        easeluz = (luz2[2])
        colluz = (luz2[3])

        if activado2 == false then --Revisa si se creó o no el sprite, si ya se creó entonces no hará estas acciones
            activado2 = true
            makeLuaSprite('luz', 'luz', -400, 400)
            setGraphicSize('luz', 2000, 400)
            setScrollFactor('luz', 0, 0.2)
            setProperty('luz.alpha', 0)
            setObjectCamera("luz", 'other');
            updateHitbox('luz')
            setProperty('luz.color',getColorFromHex(colluz))
            setBlendMode('luz', 'add')
            addLuaSprite('luz', true)
        end

        if modluz == 'normal' then --Modo flash: El modo predeterminado de uso, un flash corriente
            if pusocol == true then
                setProperty('luz.color', getColorFromHex(colluz))
            end
            setProperty('luz.alpha',opaluz)
            doTweenAlpha('luzopa','luz',0,tiempoluz,easeluz)
        end
        if modluz == 'color' then --Modo color: Tween color al que vos quieras
            alphaluz = getProperty('luz.alpha')
            colortween2 = true
            doTweenColor('luzcol','luz',colluz,tiempoluz,easeluz)
        end
        if modluz == 'alpha' then --Modo alpha: Ajusta la opacidad del sprite a lo que desees
            doTweenAlpha('luzopa','luz',opaluz,tiempoluz,easeluz)
        end
    end
    function onTweenCompleted(n)
        if n == 'luzcol' then
            colortween2 = false
            setProperty('luz.alpha', alphaluz) --Se hace por el bug que hay en psych engine con los tweens
        end 
        if n == 'luzopa' then
            if getProperty('luz.alpha') == 0 then --Revisa si la luz está invisible para eliminarlo (Optimización)
                activado2 = false
                removeLuaSprite('luz',true)
            end
        end 
    end
end

function onUpdate()
    if colortween2 == true then
        setProperty('luz.alpha', alphaluz)--Se hace por el bug que hay en psych engine con los tweens
    end
end


function split(s) --Función con la que se dividen los valores del evento
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end