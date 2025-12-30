--Creado por Roval, usalo pero deja créditos :D
activado1 = false
function onEvent(n,v1,v2)
    if n == "roval_bg" then --Al usar el evento
        local bg1 = split(v1) --Divide el value1
        local bg2 = split(v2) --Divide el value2
        local hola = v2:match('^[^,]*,[^,]*$') ~= nil --Verifica si hay 2 comas en value2
        if v1 == '' then --Si no escribes nada en v1
            bg1[1] = 0.25
            bg1[2] = 0.7
        elseif v1:match(",") == nil then --Si escribes solo el tiempo en v1
            bg1[2] = 0.7
        end
        pusocol = true
        if v2 == '' then --Si no escribes nada en v2
            pusocol = false
            bg2[1] = 'normal'
            bg2[2] = "linear"
            bg2[3] = '000000'
        elseif v2:match(",") == nil then --Si escribes solo el modo en v2
            if v2 == 'normal' or v2 == 'flash' or v2 == 'color' then
                pusocol = false
                bg2[2] = "linear"
                bg2[3] = '000000'
            else
                pusocol = true
                bg2[3] = v2
                bg2[2] = "linear"
                bg2[1] = "normal"
            end
        elseif hola then --Si escribes solo el modo y el easing en v2
            pusocol = false
            bg2[3] = '000000'
        end

        --Acá se atribuyen los valores de v1 y v2 a las variables que se usan luego
        tiempobg = (bg1[1])
        opabg = (bg1[2])

        modbg = (bg2[1])
        easebg = (bg2[2])
        colbg = (bg2[3])

        if activado1 == false then --Revisa si se creó o no el sprite, si ya se creó entonces no hará estas acciones
            activado1 = true
            makeLuaSprite('bg', '', 0, 0); 
            makeGraphic('bg', 1285*2.3, 725*2.3, 'ffffff');
            setScrollFactor('bg', 0, 0);
            screenCenter('bg');            
            setProperty('bg.alpha',0.0001)
            setProperty('bg.color',getColorFromHex(colbg))
            addLuaSprite('bg', false);
        end

        if modbg == 'normal' then --Modo normal: Ajusta la opacidad del sprite a lo que desees
            if pusocol == true then
                setProperty('bg.color', getColorFromHex(colbg))
            end
            doTweenAlpha('bgopa','bg',opabg,tiempobg,easebg)
        end
        if modbg == 'color' then --Modo color: Tween color al que vos quieras
            alphabg = getProperty('bg.alpha')
            colortween1 = true
            doTweenColor('bgcol','bg',colbg,tiempobg,easebg)
        end
        if modbg == 'flash' then --Modo flash: Ni idea para qué lo usarías, pero es un flash atras de los personajes
            if pusocol == true then
                setProperty('bg.color', getColorFromHex(colbg))
            end
            setProperty('bg.alpha',opabg)
            doTweenAlpha('bgopa','bg',0,tiempobg,easebg)
        end
    end
    function onTweenCompleted(n)
        if n == 'bgcol' then
            colortween1 = false
            setProperty('bg.alpha', alphabg) --Se hace por el bug que hay en psych engine con los tweens
        end 
        if n == 'bgopa' then
            if getProperty('bg.alpha') == 0 then --Revisa si el bg está invisible para eliminarlo (Optimización)
                activado1 = false
                removeLuaSprite('bg',true)
            end
        end 
    end
end

function onUpdate()
    if colortween1 == true then
        setProperty('bg.alpha', alphabg)--Se hace por el bug que hay en psych engine con los tweens
    end
end


function split(s) --Función con la que se dividen los valores del evento
    local resultados = {}
    for union in (s..","):gmatch("([^,%s]+)") do 
      table.insert(resultados, union)
    end
    return resultados 
end